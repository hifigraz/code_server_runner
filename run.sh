#!/usr/bin/env sh

fail() {
  exit_code=$1
  shift
  echo "$*" >&2
  exit ${exit_code} 
}

cd $(dirname $0)

trap TERM docker compose down

current_branch=$(git branch --show-current)
branch="$1"

[ -z "${branch}" ] && branch=${current_branch}

echo Branch is ${branch}

workspace=workspace_${branch}

[ -d "${workspace}" ] || fail 2 workspace ${workspace} does not exist.

if [ "${current_branch}" == "${branch}" ]; then
  echo Already on branch, not restarting
else
  echo Stopping to switch branches
  docker compose down
fi

git checkout ${branch} || fail 3 branch checkout ${branch} failed.

unlink ./workspace

ln -s ${workspace} workspace

docker compose up --build -d

url=$(cat url.txt)

[ -z ${url} ] && fail 4 no url specified

echo Try opening url: ${url}

while ( ! curl ${url} || curl ${url} | grep 404 ); do
  sleep 1
  echo -n .
done

user_data_dir=/tmp/$(id -u)/
pid_file=${user_data_dir}/pid
chromium_data_dir=${user_data_dir}/$(uuidgen)

echo chromedir ${chromium_data_dir}
echo pid file  ${pid_file}

for dir in ${user_data_dir}/*/; do
  [ -d ${dir} ] && echo rm -rf ${dir}
done
if [ -e "${pid_file}" ] && ps $(cat $pid_file); then
  kill $(cat ${pid_file})
fi

mkdir -p ${user_data_dir}
chmod 700 ${user_data_dir}

echo chromium --user-data-dir=${chromium_data_dir} --app=${url} >/dev/null 2>&1 &
chromium --user-data-dir=${chromium_data_dir} --app=${url} >/dev/null 2>&1 &

echo $! > ${pid_file}

disown

