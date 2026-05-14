# modded-nanogpt upstream baseline on 8x H200

Run: `h200-upstream-3546294-nondocker-kernels013-clean-20260514T100755Z`
Pod: `golden-fox-92` / `tokenbender-upstream-baseline-h200`
Upstream: `3546294c065bef9fc351e1d34d11c542b5c98f70`

## Result

- rc: `0`
- final val_loss: `3.2794` at step `1480/1480`
- train_time: `81354 ms`
- step_avg: `54.97 ms`
- peak memory: `31344 MiB allocated`, `45826 MiB reserved`

## Faithfulness

This used latest upstream source/config unchanged at `3546294c065bef9fc351e1d34d11c542b5c98f70` and the non-Docker README command path:

```bash
python data/cached_fineweb10B.py 9
./run.sh
```

The only environment compatibility pin is `kernels==0.13.0` installed with `--no-deps`. Current unpinned `kernels==0.14.1` fails before training with the Hugging Face kernel trust check for `varunneal/flash-attention-3`, so this pin isolates packaging/runtime drift. Kaon must use this same env for a fair optimizer-only comparison.

## Environment

- GPUs: 8x NVIDIA H200, 143771 MiB each
- driver: 580.126.09
- Python: 3.12.3
- torch: 2.10.0
- triton: 3.6.0
- kernels: 0.13.0
- fsspec: 2026.2.0
- datasets: 4.8.5

See `summary.json`, `stdout.log`, `train_log.txt`, and snapshots for exact evidence.
