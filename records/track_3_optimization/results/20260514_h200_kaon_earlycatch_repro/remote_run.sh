#!/usr/bin/env bash
set -euo pipefail

STAMP=$(date -u +%Y%m%dT%H%M%SZ)
RUN_NAME="h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-${STAMP}"
BASE="/root/work/${RUN_NAME}"
UPSTREAM="3546294c065bef9fc351e1d34d11c542b5c98f70"
POD="swift-shark-b7"
POD_NAME="tokenbender-kaon-earlycatch-h200"

mkdir -p /root/work
cd /root/work
rm -rf "$BASE"
git clone --quiet https://github.com/KellerJordan/modded-nanogpt.git "$BASE"
cd "$BASE"
git checkout -q "$UPSTREAM"

python3 -m venv .venv
source .venv/bin/activate
python -m pip install -U pip setuptools wheel
python -m pip install -r requirements.txt
python -m pip install --no-deps --force-reinstall kernels==0.13.0

python - <<'PY'
from pathlib import Path

p = Path("train_gpt.py")
s = p.read_text()

insert_marker = "\n# -----------------------------------------------------------------------------\n# Sparse Comms for bigram embedding gradient reduce-scatter\n"
kaon = r'''
# -----------------------------------------------------------------------------
# Kaon early-catchup replacement for the matrix optimizer map

@torch.compile(dynamic=False, fullgraph=True)
def kaon_express(grad_chunk: torch.Tensor, momentum_buffer: torch.Tensor, momentum_t: torch.Tensor):
    """Fused Nesterov momentum + Kaon chaotic spectral map."""
    momentum = momentum_t.to(grad_chunk.dtype)
    momentum_buffer.lerp_(grad_chunk, 1 - momentum)
    g = grad_chunk.lerp_(momentum_buffer, momentum)

    X = g.bfloat16()
    transposed = g.size(-2) > g.size(-1)
    if transposed:
        X = X.mT

    X = X / (X.norm(dim=(-2, -1), keepdim=True) + 1e-7)
    I = torch.eye(X.size(-2), device=X.device, dtype=X.dtype)
    for _ in range(5):
        A = X @ X.mT
        B = I - A
        B = B @ B
        X = 4.1 * (B @ X)

    X = X / 1.175
    if transposed:
        X = X.mT
    return X
'''
if insert_marker not in s:
    raise SystemExit("missing sparse comms marker")
s = s.replace(insert_marker, "\n" + kaon + insert_marker, 1)

old = '''        # Fused Nesterov momentum + Polar Express orthogonalization
        is_large_matrix = chunk_shape[-2] > 1024
        v_chunk = polar_express(
            grad_chunk, p_state["momentum_buffer"], self._momentum_t,
            split_baddbmm=is_large_matrix,
        )
'''
new = '''        # Fused Nesterov momentum + Kaon chaotic spectral map.
        v_chunk = kaon_express(
            grad_chunk, p_state["momentum_buffer"], self._momentum_t,
        )
'''
if old not in s:
    raise SystemExit("missing polar_express call block")
s = s.replace(old, new, 1)

old_defaults = '''        normuon_defaults = dict(
            lr=0.023,
            momentum=0.95,
            beta2=0.9,
            weight_decay=1.2,
        )
'''
new_defaults = '''        normuon_defaults = dict(
            lr=0.030,
            momentum=0.95,
            beta2=0.9,
            weight_decay=0.015,
        )
'''
if old_defaults not in s:
    raise SystemExit("missing normuon defaults block")
s = s.replace(old_defaults, new_defaults, 1)
p.write_text(s)
PY

{
  echo "run_name=$RUN_NAME"
  echo "base=$BASE"
  echo "upstream=$UPSTREAM"
  echo "pod=$POD"
  echo "pod_name=$POD_NAME"
  echo "created_at_utc=$STAMP"
} | tee metadata.env

cat > command.sh <<EOF
cd $BASE
source .venv/bin/activate
python data/cached_fineweb10B.py 9
PYTHONUNBUFFERED=1 ./run.sh
EOF

git rev-parse HEAD > upstream_commit.txt
git log -1 --format=fuller > upstream_commit_fuller.txt
git status --short > git_status_short.txt
git diff -- train_gpt.py > kaon.patch
git diff --stat -- train_gpt.py > kaon.diffstat.txt
cp train_gpt.py train_gpt.py.snapshot
cp run.sh run.sh.snapshot
cp requirements.txt requirements.txt.snapshot
python - <<'PY' > python-env.txt
import platform
import sys

print(sys.version)
print(platform.platform())
PY
python -m pip freeze > pip-freeze.txt
nvidia-smi > nvidia-smi-start.txt
nvidia-smi -q > nvidia-smi-q.txt
python - <<'PY'
import torch

print("torch", torch.__version__, "cuda", torch.version.cuda, "device_count", torch.cuda.device_count())
PY

DATA_START=$(date -u +%Y-%m-%dT%H:%M:%SZ)
python data/cached_fineweb10B.py 9
DATA_DONE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
TRAIN_START=$(date -u +%Y-%m-%dT%H:%M:%SZ)
set +e
PYTHONUNBUFFERED=1 ./run.sh > >(tee stdout.log) 2> >(tee stderr.log >&2)
RC=$?
set -e
TRAIN_DONE=$(date -u +%Y-%m-%dT%H:%M:%SZ)

LATEST_LOG=$(ls -t logs/*.txt 2>/dev/null | head -n 1 || true)
if [ -n "$LATEST_LOG" ]; then
  cp "$LATEST_LOG" train_log.txt
fi
nvidia-smi > nvidia-smi-end.txt || true

python - <<PY > summary.json
import json
import os
import platform
import re
from pathlib import Path

stdout = Path("stdout.log").read_text(errors="replace") if Path("stdout.log").exists() else ""
pat = re.compile(r"step:(\\d+)/(\\d+) val_loss:([0-9.]+|nan) train_time:([0-9.]+)ms step_avg:([0-9.]+|nan)ms")
vals = []
for m in pat.finditer(stdout):
    vals.append({
        "line": m.group(0),
        "step": int(m.group(1)),
        "total_steps": int(m.group(2)),
        "val_loss": float(m.group(3)) if m.group(3) != "nan" else None,
        "train_time_ms": float(m.group(4)),
        "step_avg_ms": float(m.group(5)) if m.group(5) != "nan" else None,
    })

train_pat = re.compile(r"step:(\\d+)/(\\d+) train_time:([0-9.]+)ms step_avg:([0-9.]+|nan)ms")
train_vals = []
for m in train_pat.finditer(stdout):
    train_vals.append({
        "step": int(m.group(1)),
        "total_steps": int(m.group(2)),
        "train_time_ms": float(m.group(3)),
        "step_avg_ms": float(m.group(4)) if m.group(4) != "nan" else None,
    })

try:
    import datasets
    import huggingface_hub
    import kernels
    import numpy
    import torch
    import triton

    env = {
        "python": platform.python_version(),
        "platform": platform.platform(),
        "torch": torch.__version__.split("+")[0],
        "torch_full": torch.__version__,
        "cuda": torch.version.cuda,
        "triton": triton.__version__,
        "kernels": kernels.__version__,
        "datasets": datasets.__version__,
        "huggingface_hub": huggingface_hub.__version__,
        "numpy": numpy.__version__,
        "device_count": torch.cuda.device_count(),
    }
except Exception as e:
    env = {"error": repr(e)}

summary = {
    "name": "$RUN_NAME",
    "run_kind": "kaon_earlycatch_h200_latest_upstream_comparison",
    "return_code": $RC,
    "pod": "$POD",
    "pod_name": "$POD_NAME",
    "upstream_repo": "https://github.com/KellerJordan/modded-nanogpt.git",
    "upstream_commit": "$UPSTREAM",
    "execution": "non-Docker README path with patched train_gpt.py: python data/cached_fineweb10B.py 9; ./run.sh",
    "env_compatibility": "same baseline env: kernels==0.13.0 with --no-deps, torch 2.10.0+cu128, fsspec 2026.2.0 expected from requirements plus pin",
    "prior_4x_curve_reference": {
        "run": "kaon-tuned-lr030-wd015-4x-torch27-paddedcollectives-20260513T211243Z",
        "reason": "this was the prior variant ahead of the 4x Muon baseline through step 2500 before crossing behind late",
        "old_4x_deltas": {
            "125": -0.05816,
            "250": -0.01432,
            "500": -0.01071,
            "1000": -0.01351,
            "1500": -0.01471,
            "2000": -0.01218,
            "2500": -0.00722,
            "3000": 0.00263,
            "3350": 0.01051
        }
    },
    "source_config_changes": [
        "added kaon_express chaotic spectral map from prior tuned Kaon probe",
        "replaced latest upstream Polar Express matrix update call with kaon_express",
        "changed normuon_defaults lr from 0.023 to 0.030",
        "changed normuon_defaults weight_decay from 1.2 to 0.015",
        "kept latest upstream model/data/schedule/Adam/NorMuon variance wrapper/communication path otherwise unchanged"
    ],
    "baseline_run": {
        "run": "h200-upstream-3546294-nondocker-kernels013-clean-20260514T100755Z",
        "val_loss": 3.2794,
        "train_time_ms": 81354,
        "step_avg_ms": 54.97
    },
    "final_validation": vals[-1] if vals else None,
    "validation_history": vals,
    "last_train_step": train_vals[-1] if train_vals else None,
    "env": env,
    "times": {
        "data_download_start_utc": "$DATA_START",
        "data_download_done_utc": "$DATA_DONE",
        "train_start_utc": "$TRAIN_START",
        "train_done_utc": "$TRAIN_DONE"
    },
    "artifacts": sorted([str(p) for p in Path(".").iterdir() if p.is_file()])
}

if vals:
    b = summary["baseline_run"]
    f = vals[-1]
    summary["comparison_to_baseline"] = {
        "delta_val_loss": f["val_loss"] - b["val_loss"] if f["val_loss"] is not None else None,
        "delta_train_time_ms": f["train_time_ms"] - b["train_time_ms"],
        "delta_step_avg_ms": f["step_avg_ms"] - b["step_avg_ms"] if f["step_avg_ms"] is not None else None,
        "kaon_won": f["val_loss"] < b["val_loss"] if f["val_loss"] is not None else False
    }

Path("summary.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\\n")
PY

cat > README.md <<EOF
# Kaon early-catchup H200 rerun

Run: \`$RUN_NAME\`
Upstream: \`$UPSTREAM\`
Pod: \`$POD\` / \`$POD_NAME\`

This reruns the prior 4x variant that was ahead of Muon through step 2500: Kaon map with \`lr=0.030\`, \`weight_decay=0.015\`.

See \`summary.json\`, \`kaon.patch\`, \`stdout.log\`, and \`train_log.txt\` for the exact result.
EOF

echo "RUN_BASE=$BASE"
echo "RUN_NAME=$RUN_NAME"
echo "RC=$RC"
exit "$RC"
