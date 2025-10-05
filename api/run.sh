#!/usr/bin/env sh
echo running api
pip install .
chmod -R a+rwX *egg-info
fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
