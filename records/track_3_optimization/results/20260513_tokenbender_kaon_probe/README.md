# Tokenbender Kaon 4x Probe

This records the first 4x NVIDIA RTX PRO 6000 Blackwell Track 3 Kaon probe
from issue #1 in the tokenbender fork.

Full raw artifacts are preserved at:

https://huggingface.co/datasets/TokenBender/modded-nanogpt-kaon-track3-artifacts

The Hugging Face artifact repo includes command lines, status files, run logs,
GPU/env snapshots, transient run scripts, and the machine-readable `summary.json`.
Generated compiler caches, data, venvs, and token files were excluded.

## Result Summary

| run | final/last validation | status |
|---|---:|---|
| `baseline-muon-4x-torch27-paddedcollectives-20260513T173211Z` | 3.27839 | finished |
| `kaon-pure-4x-torch27-paddedcollectives-20260513T184645Z` | 3.28719 | finished |
| `kaon-tuned-lr030-wd015-4x-torch27-paddedcollectives-20260513T211243Z` | 3.28890 | finished |
| `kaon-tuned-lr035-wd015-cd060-4x-torch27-paddedcollectives-20260513T221845Z` | 3.53769 at stop | stopped at step 1375 |
| `kaon-tuned-lr030-wd015-cd060-4x-torch27-paddedcollectives-20260513T224846Z` | 3.56422 at stop | stopped at step 1375 |

The clean 4x Muon baseline reached the target on this pod. Pure Kaon and the
best tuned Kaon run were materially worse at comparable run length, and the
cooldown variants were stopped because they were worse than both Muon and the
previous tuned Kaon run by step 1375.

## Included Local Files

- `train_gpt_simple_kaon.py`: pure Kaon replacement run script.
- `train_gpt_simple_kaon_tuned.py`: best completed tuned Kaon script
  (`lr=0.030`, `weight_decay=0.015`).
- `summary.json`: compact index copied from the HF export.

The baseline was run from upstream commit
`890aeba91b5f3c8b32c22d520c07991ee6ca2e2f`, with this fork's extra
Track 3 repro commit at
`292d87a98bbec49f1cde7b052b19d716a20538ae`.
