# Kaon early-catchup H200 rerun

Run: `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z`
Upstream: `3546294c065bef9fc351e1d34d11c542b5c98f70`
Pod: `swift-shark-b7` / `tokenbender-kaon-earlycatch-h200`

This reruns the prior 4x variant that was ahead of Muon through step 2500: Kaon map with `lr=0.030`, `weight_decay=0.015`.

## Result

- rc: `0`
- final val_loss: `3.2978` at step `1480/1480`
- train_time: `81710 ms`
- step_avg: `55.21 ms`
- baseline val_loss: `3.2794`
- delta val_loss: `+0.0184`

See `summary.json`, `kaon.patch`, `stdout.log`, and `train_log.txt` for the exact result.
