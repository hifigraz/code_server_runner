#!/usr/bin/env sh

fail() {
  exit_code=$1
  shift
  echo "$*" >&2
  exit ${exit_code} 
}

cd $(dirname $0)

branch="$1"

[ -z "${branch}" ] && fail 1 No branch given

echo Branch is ${branch}

workspace=workspace_${branch}

[ -d "${workspace}" ] || fail 2 workspace ${workspace} does not exist.

docker compose down

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

chromium --app=${url}
