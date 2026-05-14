# H200 upstream repro

- Pod: `gentle-lion-96`
- Hardware: 8x NVIDIA H200
- Upstream commit: `890aeba91b5f3c8b32c22d520c07991ee6ca2e2f`
- Command: upstream `./run.sh` after `python data/cached_fineweb10B.py 9`
- Environment-only drift correction: `kernels==0.13.0`; no upstream source or run script edits.
- Result: `step:1480/1480 val_loss:3.2791 train_time:81361ms step_avg:54.97ms`

The first exact unpinned environment resolved `kernels==0.14.0` and failed before training because the package now requires `trust_remote_code=True` for `varunneal/flash-attention-3`. This run keeps the upstream checkout unchanged and pins the nearest prior `kernels` release that preserves the old call contract.
