#!/usr/bin/sh

running=1
WORKSPACE_LINK=/workspace/front
if [ ! -e "${WORKSPACE_LINK}" ]; then
  mkdir -p ${WORKSPACE_LINK}
  echo Please clone frontent into /config/workspace >> ${WORKSPACE_LINK}/README.md
fi
stop_server() {
  running=0
}
trap stop_server TERM 

echo waiting for run_app.sh
while [ "${running}" -ne "0" ]; do
  run_sh=$(find /workspace -name run_app.sh)
  if [ -n "${run_sh}" ]; then
    rm -rf ${WORKSPACE_LINK}
    ln -s $(basename $(dirname ${run_sh})) ${WORKSPACE_LINK}
    echo starting app
    chmod +x ${run_sh}
    cd $(dirname ${run_sh})
    ${run_sh}
  else
    sleep 1
    echo -n .
  fi
done
