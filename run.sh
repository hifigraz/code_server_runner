#!/usr/bin/env sh
cd $(dirname $0)

fail() {
  exit_code=$1
  shift
  echo "$*" >&2
  exit ${exit_code} 
}

stop_container() {
  echo STOPPING CONTAINER
  docker compose down
}

start_container() {
  EXTENSION_FILE=./code/root/etc/s6-overlay/s6-rc.d/code-plugins/extensions.txt
  echo STARTING CONTAINER
  echo auiworks.amvim >> ${EXTENSION_FILE}
  docker compose up --build -d
  head -n -1 ${EXTENSION_FILE} > ${EXTENSION_FILE}.tmp ; mv ${EXTENSION_FILE}.tmp ${EXTENSION_FILE}
}

trap stop_container SIGTERM SIGINT

current_branch=$(git branch --show-current)
branch="$1"
[ -z "${branch}" ] && branch=${current_branch}

workspace=workspace_${branch}

echo Current Branch is: ${current_branchbranch}
echo Desired Branch is: ${branch}
echo Workspace is:      ${workspace}

[ -d "${workspace}" ] || fail 2 workspace ${workspace} does not exist.

if [ "${current_branch}" == "${branch}" ]; then
  echo Already on branch, skipping restart
else
  stop_container
fi

git checkout ${branch} || fail 3 branch checkout ${branch} failed.
url=$(cat url.txt)
[ -z ${url} ] && fail 4 no url specified

unlink ./workspace
ln -s ${workspace} workspace

start_container

user_data_dir="/tmp/$(id -u)/container/"
mkdir -p ${user_data_dir}
chmod 700 ${user_data_dir}

for dir in ${user_data_dir}/*/; do
  echo checking user dir ${dir} 
  old_pid_file=${dir}/pid
  if [ -e ${old_pid_file} ] ; then
    old_pid=$(cat ${old_pid_file})
    Checking PID ${old_pid}
    ps ${old_pid} | grep chromium && kill ${old_pid}
  else
    echo no old pid file found
  fi
  echo cleaning dir
  [ -d ${dir} ] && rm -rf ${dir}
done


echo Try opening url: ${url}
while ( ! curl ${url} || curl ${url} | grep 404 ); do
  sleep 1
  echo -n .
done


chromium_data_dir="${user_data_dir}$(uuidgen)/"
pid_file="${chromium_data_dir}pid"
echo chromedir "${chromium_data_dir}"
echo pid file  "${pid_file}"
mkdir -p ${chromium_data_dir}

echo chromium --user-data-dir=${chromium_data_dir}data --app=${url} >/dev/null 2>&1 &
chromium --user-data-dir=${chromium_data_dir}data --app=${url} >/dev/null 2>&1 &
chromium_pid=$!

cd "${chromium_data_dir}"
echo ${chromium_pid} > pid

disown

