#!/bin/zsh

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

for zscaler_proc in $(ps -ef | grep -i "zscaler" | grep -v "grep" | awk '{print $2}'); do
  sudo kill -9 $zscaler_proc
done
