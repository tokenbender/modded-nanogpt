# Tokenbender Track 3 Repro

This fork keeps a runnable extraction of the current Track 3 optimizer record:

- Source result: `results/20260509_contra_soft_muon/03c36e81-e2e5-4916-bf16-0141999b1dbb.txt`
- Extracted script: `train_gpt_contra_soft_muon_repro.py`
- Upstream record: 3030 steps to 3.28, Contra-Muon plus Soft-Muon interpolation

The extracted script is the content of the source logfile before the first
`===` separator, kept as a normal Python entrypoint so it can be launched
without manual copy-paste.

## Run

```bash
pip install torch==2.11 huggingface_hub
python data/cached_fineweb10B.py 20
torchrun --standalone --nproc_per_node=$(nvidia-smi -L | wc -l) \
  records/track_3_optimization/train_gpt_contra_soft_muon_repro.py
```

This benchmark needs an NVIDIA GPU machine. It is intended for A100/H100-style
systems matching the Track 3 README constraints.
