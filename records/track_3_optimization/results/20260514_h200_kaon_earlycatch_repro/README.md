# H200 Kaon early-catchup rerun

This records the 8x H200 rerun of the prior 4x Kaon variant that was ahead of
the Muon baseline through step 2500 before losing late.

## Run

- run: `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z`
- pod: `swift-shark-b7` / `tokenbender-kaon-earlycatch-h200`
- upstream: `3546294c065bef9fc351e1d34d11c542b5c98f70`
- execution: non-Docker README path, `python data/cached_fineweb10B.py 9`; `./run.sh`
- environment: Python 3.12.3, torch 2.10.0+cu128, triton 3.6.0, kernels 0.13.0

The only source/config changes were the Kaon matrix map replacement and
`normuon_defaults` changed from `lr=0.023`, `weight_decay=1.2` to `lr=0.030`,
`weight_decay=0.015`.

## Result

| step | H200 baseline | Kaon early-catchup | delta |
|---:|---:|---:|---:|
| 0 | 10.8317 | 10.8327 | +0.0010 |
| 250 | 4.5079 | 4.5018 | -0.0061 |
| 500 | 4.2133 | 4.2129 | -0.0004 |
| 750 | 3.7960 | 3.7965 | +0.0005 |
| 1000 | 3.5095 | 3.5075 | -0.0020 |
| 1250 | 3.3676 | 3.3759 | +0.0083 |
| 1480 | 3.2794 | 3.2978 | +0.0184 |

Final result: Kaon did not beat the latest-upstream H200 baseline. It remained
close early, crossed behind by step 1250, and finished `+0.0184` val loss worse.

## Artifacts

- `remote_run.sh`: exact pod setup and launch script.
- `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z/summary.json`
- `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z/kaon.patch`
- `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z/stdout.log`
- `h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z/train_log.txt`
