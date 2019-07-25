#!/usr/bin/env bash
while true; do 
    if [[ -f /sys/class/power_supply/BAT0/present && 
        $(cat /sys/class/power_supply/BAT0/present) == 1 ]] ; then
            BATTERY_PCT=$(cat /sys/class/power_supply/BAT0/capacity)
            BATTERY_STATE=$(cat /sys/class/power_supply/BAT0/status)
            BATTERY="Battery $BATTERY_PCT% $BATTERY_STATE, "
    fi
    DATE=$(date +'%Y-%m-%d %k:%M:%S')
    printf "%s\n" "$BATTERY$DATE"
    sleep 1
done
