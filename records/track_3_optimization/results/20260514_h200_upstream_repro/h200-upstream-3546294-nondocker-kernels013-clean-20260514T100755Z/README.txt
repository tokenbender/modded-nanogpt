kind=h200_upstream_nondocker_baseline_comparison_env
upstream_commit=3546294c065bef9fc351e1d34d11c542b5c98f70
source_config_edits=none
comparison_env=true
compatibility_note=Installed upstream requirements, then replaced only kernels with 0.13.0 using --no-deps because current unpinned kernels 0.14.1 rejects upstream get_kernel('varunneal/flash-attention-3') before training. Kaon must use this exact environment for comparison.
commands=python data/cached_fineweb10B.py 9; ./run.sh
