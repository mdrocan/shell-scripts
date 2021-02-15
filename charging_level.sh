#!/bin/sh

batterylevel=$(pmset -g batt | sed 1d | awk '{print$3}' | sed 's/..$//')

charge_state=$(pmset -g batt | sed 1d | awk '{print$4}' | sed 's/.$//')

charge_state2=$(pmset -g batt | sed 1d | awk '{for (i=4; i<NF; i++) printf $i " "; print $NF}')

notification30 () {
osascript -e 'display notification "Battery level below 30%." with title "Check charging!"'
}

charge_state_inactive () {
osascript -e 'display notification "Battery is discharging currently." with title "Check charging!"'
}

if [ "$batterylevel" -lt 30 ]; then
  notification30
else
  exit 0
fi

if [ "$charge_state" = "discharging" ] || [ "$charge_state2" = "AC attached; not charging present: true" ]; then
  charge_state_inactive
else
  exit 0
fi