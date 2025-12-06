#!/usr/bin/sh

running=1

stop_server() {
  running=0
}
trap stop_server TERM 

echo waiting for run_app.sh
while [ "${running}" -ne "0" ]; do
  run_sh=$(find /workspace -name run_app.sh)
  if [ -n "${run_sh}" ]; then
    echo starting app
    chmod +x ${run_sh}
    cd $(dirname ${run_sh})
    ${run_sh}
  else
    sleep 1
    echo -n .
  fi
done
