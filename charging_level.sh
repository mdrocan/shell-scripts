#!/bin/sh

batterylevel=$(pmset -g batt | sed 1d | awk '{print$3}' | sed 's/..$//')

notification30 () {
osascript -e 'display notification "Battery level 30%" with title "Check charging!"'
}

if [ "$batterylevel" -lt 30 ]; then
  notification30
else
  exit 0
fi