#!/bin/sh

notification () {
osascript -e 'display notification "Battery level 50%" with title "Check charging!"'
}

if 
  pmset -g batt | sed 1d | awk '{print$3}' | grep -q "50%"; then
     notification
else
  exit 0
fi