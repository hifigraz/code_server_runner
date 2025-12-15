#!/usr/bin/env sh


log() {
  echo LOG $* >&2
}

fail() {
  exit_code=$1
  shift
  log $*
  exit ${exit_code}
}

running=1

linkFiles() {
  log linkFiles called with $*
  cd $1
  while [ "0" -ne "${running}" ]; do
    mkdir -p /workspace/
    for i in $(ls -A /$1 | grep -v egg-info); do
      if [ -e /workspace/${i} ]; then
        log skipping file $1/$i
      else
        log "linkFile $1/$i -> /workspace/$i"
        ln -s $1/$i /workspace/$i
      fi
    done
    sleep 5
  done
}

stop_server() {
  running=0
}
trap stop_server TERM 

getWorkDir() {
  log getWorkDir looking for pyproject.toml
  for i in $(find /workspace_ro -name pyproject.toml); do
    log getWorkDir got pyproject.toml
    echo $(dirname $i)
    return 0
  done
  return 1
}

log running api
while [ "${running}" -ne "0" ]; do
  do_break=0
  PACKAGE_DIR=$(getWorkDir)
  if [ 0 -eq $? ]; then
    linkFiles ${PACKAGE_DIR} &
    break
  fi
  log waiting for project
  sleep 5
done
  
cd /workspace

if [ "${running}" -ne "0" ] && [ -e "pyproject.toml" ]; then
  log installing package
  pip install .
fi

echo starting api
while [ "${running}" -ne "0" ]; do
  log files $(ls /workspace/)
  find -L -name scripts.py | grep -v ^./build

  script_name="$(find -L -name scripts.py |grep -v ^./build)"
  echo "Script ${script_name}"

  fastapi dev ${script_name} --host 0.0.0.0 --port 80 --proxy-headers --root-path /api
  echo restarting api
  sleep 5
done

