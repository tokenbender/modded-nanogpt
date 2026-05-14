cd /root/work/modded-nanogpt-upstream-baseline
source .venv/bin/activate
python data/cached_fineweb10B.py 9
PYTHONUNBUFFERED=1 ./run.sh
