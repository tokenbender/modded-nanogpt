# 8x H200 tuned Kaon repro

This records the latest-upstream H200 comparison for the prior tuned Kaon
variant from the TokenBender probe.

- Upstream commit: `3546294c065bef9fc351e1d34d11c542b5c98f70`
- Pod: `golden-fox-92`
- Pod name: `tokenbender-upstream-baseline-h200`
- Hardware: 8x NVIDIA H200
- Method: non-Docker README path
- Baseline environment: same as `20260514_h200_upstream_repro`
- Source/config changes: add the Kaon chaotic spectral map, replace the latest
  upstream Polar Express matrix update call with Kaon, and use tuned matrix
  defaults `lr=0.030`, `weight_decay=0.015`
- Local artifacts: `h200-kaon-tuned-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T104753Z/`
- HF artifacts: https://huggingface.co/datasets/TokenBender/modded-nanogpt-kaon-track3-artifacts/tree/main/h200_kaon_tuned_repro/h200-kaon-tuned-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T104753Z

Result:

```text
step:1480/1480 val_loss:3.2958 train_time:81839ms step_avg:55.30ms
```

Baseline for the same upstream commit and environment:

```text
step:1480/1480 val_loss:3.2794 train_time:81354ms step_avg:54.97ms
```

Outcome: this tuned Kaon port did not beat the latest upstream baseline. It was
`+0.0164` worse in final validation loss and `+485ms` slower.
