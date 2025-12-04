#!/usr/bin/env sh

# Setup everythin for every_shell_script

USAGE=$(cat << EOF
usage: $(basename $0) [-v,--verbose] [-b,--branch <branchname>] [--vim] [-h,--help] [start|stop|restart|reload|log]
  -h, --help                  show this help message and exit
  -v, --verbose               provide a verbose output
      --vim                   enable vim motions plugin
  -b, --branch <branchname>   check and switch to branch <branchname>.
                              If a branch switch is detected, container will be stopped first
    commands:
      start                   build and start container
      stop                    stops container
      restart                 restart container
      reload                  lifereload changed containers
      log                     show and follow logfiles
EOF
)

RUNNING=true

clean_up() {
  RUNNING=false
  log_info Bye!
}

# Default way to load every_shell_script

which every_shell_script.sh >/dev/null 2>&1 && . $(every_shell_script.sh) || {
  echo install https://github.com/hifigraz/every_shell_script.sh >&2
  exit 255
}

usage() {
  printf "%s\n" "${USAGE}"
}

fail() {
  exit_code=$1
  shift
  log_error $*
  clean_up
  exit ${exit_code}
}

# Variables here 

CMD=start
VIM="no"
VERBOSE=0
WORKDIR=$(cd $(dirname $0); pwd)
cd ${WORKDIR}
BRANCH=$(git branch --show-current)
CHROMIUM_DIR=${TMP_USER}/container/
mkdir -p ${CHROMIUM_DIR}

# Main 

main() {
  while [ "$#" -ge 1 ]; do
    case "$1" in
      -v | --verbose)
        LOG_LEVEL=1
        log_debug Debugging enable
        shift
        ;;
      -h | --help)
        usage
        exit 0
        ;;
      --vim)
        VIM="yes"
        shift
        ;;
      -b | --branch)
        if [ -z "$2" ]; then
          fail 2 $1 needs a branch name given
        else
          BRANCH=$2
          shift
          shift
        fi
        ;;
      *)
        case "$1" in
          start)
            CMD=$1
            ;;
          stop)
            CMD=$1
            ;;
          restart)
            CMD=$1
            ;;
          reload)
            CMD=$1
            ;;
          log)
            CMD=$1
            ;;
          *)
          fail 1 unknown parameter $1
          ;;
        esac
        shift
        ;;
    esac
  done

  log_info COMMAND: ${CMD}
  log_debug BRANCH: ${BRANCH}
  log_debug WORKDIR: ${WORKDIR}

  case ${CMD} in
    start)
      switch_branch
      start_container
      start_browser
      ;;
    stop)
      stop_browser
      stop_container
      switch_branch
      ;;
    restart)
      stop_container
      switch_branch
      start_container
      ;;
    reload)
      switch_branch
      start_container
      ;;
    log)
      follow_logs
      ;;
    *)
      fail 20 unknwon command ${CMD}
      ;;
  esac
}


update_config() {
  log_debug Pulling config
  git pull --all
}

update_images() {
  log_debug Pulling images
  docker compose pull
}

stop_container() {
  log_debug shutdown 
  docker compose down
}

start_container() {
  EXTENSION_FILE=./code/root/etc/s6-overlay/s6-rc.d/code-plugins/extensions.txt
  log_debug building build and start 
  if [ "${VIM}" = "yes" ]; then
    echo auiworks.amvim >> ${EXTENSION_FILE}
  fi
  docker compose up --build -d
  log_debug is up, unpatching extension file
  grep -v auiworks.amvim ${EXTENSION_FILE} > ${EXTENSION_FILE}.tmp 
  mv ${EXTENSION_FILE}.tmp ${EXTENSION_FILE}
  log_debug start finished
}

switch_branch() {
  log_debug switching branch
  current_branch=$(git branch --show-current)
  if [ "${BRANCH}" != "${current_branch}" ]; then
    stop_container
    git checkout ${BRANCH} || fail 10 Switching branch failed
  fi
}

follow_logs() {
  log_debug following log files
  docker compose logs --follow
}

start_browser() {
  url=$(head -n 1 url.txt | sed s/#.*//)
  count=0
  log_info Try opening url: ${url}
  while ( ! curl ${url} >/dev/null 2>&1 || curl ${url} 2>&1 | grep 404 > /dev/null 2>&1); do
    sleep 1
    echo -n . >&2
    let count=count+1
    if [ ${count} -gt 20 ] ; then
      fail 30 code server still not reachable
    fi
    if [ ! ${RUNNING} ]; then
      break
    fi
  done
  chromium --user-data-dir=${CHROMIUM_DIR}/data --app=${url} >/dev/null 2>&1 &
  echo $! > ${CHROMIUM_DIR}/pid
}

stop_browser() {
  kill $(cat ${CHROMIUM_DIR}/pid)
}

main $*
clean_up
exit 0

