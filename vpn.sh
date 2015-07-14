#!/bin/bash

time=0
timeout=10

case "$1" in
  start)
    if [[ -z $(ifconfig | grep tun) ]]; then
      if [[ -n $(ifconfig | egrep "enp0s20u3u1u3c2|eth0") ]]; then
        sudo ip link set wlp3s0 down
      fi
      echo -n "Connecting to webvpn.automotive.com" && notify-send "Connecting to webvpn.automotive.com"
      screen -dmS vpn /home/william/Scripts/q4vpn.exp
      while [[ -z $(ifconfig | grep tun) ]] && [[ $time -le $timeout ]]; do
        sleep 1 && echo -n "."
        time=$((time+1))
      done
      while [[ -n $(ifconfig | grep tun) ]]; do
        yad --notification --image vpn --text "VPN connected" --command="/home/william/Scripts/vpn.sh stop"
      done > /dev/null 2>&1 &
      if [[ $time -le $timeout ]]; then
        echo -e "\nConnected successfully." && notify-send "Connected to VPN"
      else
        sudo pkill openconnect
        echo -e "\nConnection timed out. Operation aborted." && notify-send "VPN connection failed"
      fi
    else
      echo "tun network device already exists. Is the VPN already running?" && notify-send "VPN connected"
    fi
    ;;
  stop)
    sudo pkill openconnect
    pkill yad
    sudo resolvconf -d tun0
    sudo ip link set wlp3s0 up
    sudo dhcpcd wlp3s0
    echo "VPN connection stopped." && notify-send "VPN connection stopped"
    ;;
  *)
    echo "Usage: vpn (start|stop)"
esac
