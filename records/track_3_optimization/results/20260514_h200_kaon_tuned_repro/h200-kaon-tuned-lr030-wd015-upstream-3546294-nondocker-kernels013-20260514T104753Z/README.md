# Kaon tuned H200 comparison

Run: `h200-kaon-tuned-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T104753Z`
Upstream: `3546294c065bef9fc351e1d34d11c542b5c98f70`
Pod: `golden-fox-92` / `tokenbender-upstream-baseline-h200`

## Result

- rc: `0`
- final val_loss: `3.2958` at step `1480/1480`
- train_time: `81839 ms`
- step_avg: `55.3 ms`
- baseline val_loss: `3.2794`
- delta val_loss: `+0.0164`

## Patch

This is the prior tuned Kaon idea carried onto latest upstream: Kaon chaotic spectral map replaces the matrix update map, and matrix defaults use `lr=0.030`, `weight_decay=0.015`. Model, data, schedule, Adam path, communication path, and the baseline package env are otherwise unchanged.

See `summary.json`, `kaon.patch`, `stdout.log`, and `train_log.txt` for evidence.
