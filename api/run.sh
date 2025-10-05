#!/usr/bin/env sh

running=1

stop_server() {
  running=0
}

trap SIGTERM stop_server 

echo running api
while [ "${running}" -ne "0" && ! -e "pyproject.toml" ]; do
  echo waiting for project
  sleep 5
done

if [ "${running}" -ne "0" && -e "pyproject.toml" ]; then
  echo installing package
  pip install .
  chmod -R a+rwX *egg-info
fi

echo starting api
while [ "${running}" -ne "0" ]; do
  fastapi dev IVahit/scripts.py --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  echo restarting api
  sleep 5
done

