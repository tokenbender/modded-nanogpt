# 8x H200 upstream repros

This records upstream modded-nanogpt repros on 8x NVIDIA H200 pods.

## Latest upstream baseline, 2026-05-14 10:16 UTC

- Upstream commit: `3546294c065bef9fc351e1d34d11c542b5c98f70`
- Pod: `golden-fox-92`
- Pod name: `tokenbender-upstream-baseline-h200`
- Hardware: 8x NVIDIA H200
- Method: non-Docker README path
- Command: `python data/cached_fineweb10B.py 9`, then upstream `./run.sh`
- Source/config edits: none
- Environment compatibility pin: `kernels==0.13.0` installed with `--no-deps`
- Local artifacts: `h200-upstream-3546294-nondocker-kernels013-clean-20260514T100755Z/`
- HF artifacts: https://huggingface.co/datasets/TokenBender/modded-nanogpt-kaon-track3-artifacts/tree/main/h200_upstream_repro/h200-upstream-3546294-nondocker-kernels013-clean-20260514T100755Z

Result:

```text
step:1480/1480 val_loss:3.2794 train_time:81354ms step_avg:54.97ms
```

The upstream `master` ref was verified after the run and still pointed at
`3546294c065bef9fc351e1d34d11c542b5c98f70`. This is the baseline environment to
reuse for Kaon comparison so optimizer changes are not confounded with package
drift.

## Earlier H200 baseline, 2026-05-14 04:57 UTC

- Upstream commit: `890aeba91b5f3c8b32c22d520c07991ee6ca2e2f`
- Pod: `gentle-lion-96`
- Hardware: 8x NVIDIA H200
- Command: `python data/cached_fineweb10B.py 9`, then upstream `./run.sh`
- HF artifacts: https://huggingface.co/datasets/TokenBender/modded-nanogpt-kaon-track3-artifacts/tree/main/h200_upstream_repro/h200-upstream-890aeba-kernels013-20260514T045751Z

Result:

```text
step:1480/1480 val_loss:3.2791 train_time:81361ms step_avg:54.97ms
```

The first unpinned environment resolved `kernels==0.14.0` and failed before
training because that package now requires `trust_remote_code=True` for
`varunneal/flash-attention-3`. The successful run left upstream source and
`run.sh` unchanged and pinned `kernels==0.13.0`, the nearest prior release that
preserves the old `get_kernel(...)` call contract.
