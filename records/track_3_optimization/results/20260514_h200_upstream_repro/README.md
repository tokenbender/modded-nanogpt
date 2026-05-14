# 8x H200 upstream repro

This records an upstream-latest modded-nanogpt repro on an 8x NVIDIA H200 pod.

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
