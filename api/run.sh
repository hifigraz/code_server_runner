#!/usr/bin/env sh
running=true
stop_server() {
  running=false
}
trap SIGTERM stop_server 

echo running api
while [ ${running} && ! -e pyproject.toml ]; do
  sleep 5
done
if [ ${running} && -e pyproject.toml ]; then
  echo installing package
  pip install .
  chmod -R a+rwX *egg-info
fi
echo starting api
while ${running}; do
  fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  echo restarting api
  sleep 5
done

