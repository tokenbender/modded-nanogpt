set -euo pipefail
cd /root/work
rm -rf modded-nanogpt-strict
export GIT_TERMINAL_PROMPT=0
git clone https://github.com/KellerJordan/modded-nanogpt.git modded-nanogpt-strict
cd modded-nanogpt-strict
git checkout 0a7ba0b1c6d8d38bd74491eff05b49c78c741ad7
docker build -t modded-nanogpt .
docker run --rm --gpus all -v $(pwd):/modded-nanogpt modded-nanogpt python data/cached_fineweb10B.py 8
docker run --rm --gpus all -v $(pwd):/modded-nanogpt modded-nanogpt sh run.sh
