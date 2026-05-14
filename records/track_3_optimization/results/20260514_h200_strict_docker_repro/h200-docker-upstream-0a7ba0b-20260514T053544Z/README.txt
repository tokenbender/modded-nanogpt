strict_faithfulness=true
upstream_commit=0a7ba0b1c6d8d38bd74491eff05b49c78c741ad7
upstream_head_checked_utc=2026-05-14T05:35:44Z
method=README Docker path
commands=docker build -t modded-nanogpt .; docker run --rm --gpus all -v \/root:/modded-nanogpt modded-nanogpt python data/cached_fineweb10B.py 8; docker run --rm --gpus all -v \/root:/modded-nanogpt modded-nanogpt sh run.sh
