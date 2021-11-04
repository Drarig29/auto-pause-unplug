#!/bin/bash

for pid in $(pgrep -f $0); do
    if [ $pid != $$ ]; then
        kill $pid
    fi
done

log() {
  printf "[$$] $1" | systemd-cat
  echo "$1"
}

set +e

pactl subscribe | while read -r line
do
  if grep -q "'change' on card"; then
    if !(pactl list sinks | grep -qE "Active Port.*Headphones"); then
      log "Headphones unplugged. Pausing..."
      playerctl pause
    fi
  fi
done
