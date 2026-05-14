# 8x H200 strict Docker repro

This records the 100% faithful upstream Docker repro attempt.

- Upstream commit: `0a7ba0b1c6d8d38bd74491eff05b49c78c741ad7`
- Pod: `gentle-lion-96`
- Hardware: 8x NVIDIA H200
- Method: upstream README Docker path
- Source/config edits: none
- HF artifacts: https://huggingface.co/datasets/TokenBender/modded-nanogpt-kaon-track3-artifacts/tree/main/h200_strict_docker_repro/h200-docker-upstream-0a7ba0b-20260514T053544Z

Commands:

```bash
docker build -t modded-nanogpt .
docker run --rm --gpus all -v $(pwd):/modded-nanogpt modded-nanogpt python data/cached_fineweb10B.py 8
docker run --rm --gpus all -v $(pwd):/modded-nanogpt modded-nanogpt sh run.sh
```

Result: failed before training with `rc=1`.

```text
ce_fwd_bwd_kernel.cu(43): error: identifier "__tanhf" is undefined
```

The Dockerfile resolved `torch-2.13.0.dev20260513+cu126` from the unpinned
nightly upgrade step. No package pins, source changes, or run-script changes
were applied to get past this.
