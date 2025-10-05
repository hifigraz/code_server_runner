#!/usr/bin/env sh
echo running api
while [ ! -e pyproject.toml ]; do
  sleep 5
done
echo installing package
pip install .
chmod -R a+rwX *egg-info
echo starting api
while true; do
  fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  echo restarting api
  sleep 5
done

