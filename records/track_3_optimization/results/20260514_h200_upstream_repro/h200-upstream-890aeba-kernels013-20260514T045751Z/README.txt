# H200 upstream exact run
repo=/root/work/modded-nanogpt-upstream
commit=890aeba91b5f3c8b32c22d520c07991ee6ca2e2f
date_utc=2026-05-14T04:57:51Z
dependency_note=kernels pinned to 0.13.0 because 0.14.0 requires trust_remote_code for varunneal/flash-attention-3 before training starts; upstream source and run.sh are unchanged.
commands:
  cd /root/work/modded-nanogpt-upstream
  source .venv/bin/activate
  pip install --force-reinstall kernels==0.13.0
  python data/cached_fineweb10B.py 9
  ./run.sh
