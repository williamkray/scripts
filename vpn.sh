#!/bin/bash

time=0
timeout=10

case "$1" in
  start)
    string=$(yad --center --title "Openconnect" --image "vpn" --text "VPN connection info:" --form --field="URL" --field="Username" --field="Password":H)

    url=$(echo $string|awk -F '|' '{print $1}')
    username=$(echo $string|awk -F '|' '{print $2}')
    password=$(echo $string|awk -F '|' '{print $3}')

    if [[ -z $url ]] || [[ -z $username ]] || [[ -z $password ]]; then
      echo "Cancelling"
      exit 0
    fi

    if [[ -z $(ifconfig | grep tun) ]]; then
      if [[ -n $(ifconfig | egrep "enp0s20u3u1u3|eth0") ]]; then
        sudo ip link set wlp3s0 down
      fi
      echo -n "Connecting to $url" && notify-send "Connecting to $url"
      screen -dmS vpn launchvpn.exp $url $username $password
      while [[ -z $(ifconfig | grep tun) ]] && [[ $time -le $timeout ]]; do
        sleep 1 && echo -n "."
        time=$((time+1))
      done
      while [[ -n $(ifconfig | grep tun) ]]; do
        yad --notification --image vpn --text "VPN connected: $url" --command="" --menu 'Disconnect!vpn.sh stop'
      done > /dev/null 2>&1 &
      if [[ $time -le $timeout ]]; then
        echo -e "\nConnected successfully." && notify-send "Connected to VPN"
      else
        sudo pkill openconnect
        echo -e "\nConnection timed out. Operation aborted." && notify-send "VPN connection failed"
        sudo ip link set wlp3s0 up
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
    rm $PIPE
    ;;
  *)
    echo "Usage: vpn (start|stop)"
esac
