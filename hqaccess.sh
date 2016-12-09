#!/bin/bash

desired_essid="<enter_essid_here>"
quality_threshold=35 #lowest connection quality before searching for another

ifconfig wlan0 down
killall wpa_supplicant
dhclient -r
re='^[0-9]+$'
echo

while true; do
  wlan="$(tail -n 1 /proc/net/wireless)"
  wlanlist=( $wlan )
  quality="${wlanlist[2]//.}"
  if [[ "$quality" =~ $re ]] && [ "$quality" -gt "$quality_threshold" ]; then
    echo "$(date +%T)       Quality: ${quality}/70"
  else
    echo "$(date +%T)       Quality: ${quality}/70"
    ifconfig wlan0 down
    dhclient -r
    ifconfig wlan0 up
    sudo iwlist wlan0 scan > tempfilebabyyy
    access_point="$(python ~/.wifi/best_ap.py tempfilebabyyy $desired_essid)"
    rm tempfilebabyyy 
    echo 
    iwconfig wlan0 essid "$desired_essid" ap "$access_point"
    timeout 15 dhclient wlan0
    [ $? -eq 124 ] && echo timed out && continue
  fi
  sleep 10
done
