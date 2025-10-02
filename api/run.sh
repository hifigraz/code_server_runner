#!/usr/bin/env sh
pwd
pip install .
fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
