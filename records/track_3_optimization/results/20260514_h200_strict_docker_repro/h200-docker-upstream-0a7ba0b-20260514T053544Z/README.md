# Strict H200 Docker repro

This is the 100% faithful upstream Docker repro attempt.

- Pod: `gentle-lion-96`
- Hardware: 8x NVIDIA H200
- Upstream commit: `0a7ba0b1c6d8d38bd74491eff05b49c78c741ad7`
- Method: upstream README Docker path
- Source/config edits: none
- Result: failed before training, `rc=1`
- Failure: `NVRTC compile failure: identifier "__tanhf" is undefined in ce_fwd_bwd_kernel.cu`

The Docker image was built from upstream `Dockerfile` using `FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu24.04`. The run used `python data/cached_fineweb10B.py 8` followed by `sh run.sh`, matching the README Docker commands.
