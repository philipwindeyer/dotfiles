#!/bin/zsh

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

function kill_all_the_procs() {
  echo "killing $1"
  for proc in $(ps -ef | grep -i "$1" | grep -v "grep" | awk '{print $2}'); do
    sudo kill -9 $proc
  done
}

kill_all_the_procs zscaler
kill_all_the_procs falcon
