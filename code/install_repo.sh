#!/usr/bin/env sh

usage() {
  $(basename $0) >>cloneable repo address<<
  exit 1
}

repo=$1
[ -z "${repo}" ] && usage

git clone ${repo} /config/workspace
