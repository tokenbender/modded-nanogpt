cd /root/work/modded-nanogpt-kaon-tuned-h200-20260514T104753Z
source .venv/bin/activate
python data/cached_fineweb10B.py 9
PYTHONUNBUFFERED=1 ./run.sh
