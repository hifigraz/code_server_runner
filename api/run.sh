#!/usr/bin/env sh
echo running api
pip install .
chmod -R a+rwX *egg-info
while [ ! -e IVahit/scripts.py ]; do
  sleep 5
done
while true; do
  fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  sleep 5
done
