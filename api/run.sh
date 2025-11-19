#!/usr/bin/env sh

running=1

stop_server() {
  running=0
}
trap stop_server TERM 

getWorkDir() {
  for i in */; do
    if [ -d "$i" ]; then
      cd $i
      if [ -e "pyproject.toml" ]; then
        pwd
        return 0
      fi
      cd ..
    fi
  done
  return 1
}



echo running api
while [ "${running}" -ne "0" ]; do
  getWorkDir && break
  echo waiting for project
  sleep 5
done

if [ "${running}" -ne "0" ] && [ -e "pyproject.toml" ]; then
  echo installing package
  pip install .
  chmod -R a+rwX *egg-info
fi

echo starting api
while [ "${running}" -ne "0" ]; do
  script_name="$(find -name scripts.py |grep -v ^./build)"
  echo "Script ${script_name}"
  fastapi dev "${script_name}" --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  echo restarting api
  sleep 5
done

