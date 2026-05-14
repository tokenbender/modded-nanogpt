cd /root/work/h200-kaon-earlycatch-lr030-wd015-upstream-3546294-nondocker-kernels013-20260514T121022Z
source .venv/bin/activate
python data/cached_fineweb10B.py 9
PYTHONUNBUFFERED=1 ./run.sh
