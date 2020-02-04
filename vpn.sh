#!/bin/bash

time=0
timeout=30

function sendmessage() {
  tmpfile="/tmp/vpn-id"
  local notifycmd="notify-desktop"
  if [ -f $tmpfile ]; then
    notifycmd="$notifycmd -r $(cat $tmpfile)"
  fi
  local msg="$1"
  echo -e "$msg"
  $notifycmd "$msg" > /tmp/vpn-id
}

case "$1" in
  start)
    string=$(yad --center --title "VPN Connector" --image "vpn" --text "VPN connection info" --form --field="URL/file" --field="Username" --field="Password":H --field="Connection Type ":CB "" "" "" "Cisco (OpenConnect)!^OpenVPN" --field="2FA")

    url=$(echo $string|awk -F '|' '{print $1}')
    username=$(echo $string|awk -F '|' '{print $2}')
    password=$(echo $string|awk -F '|' '{print $3}')
    conn_type=$(echo $string|awk -F '|' '{print $4}')
    #2fa=$(echo $string|awk -F '|' '{print $5}')

    if [[ -z $url ]] || [[ -z $username ]] || [[ -z $password ]]; then
      echo "Cancelling"
      exit 0
    fi

    if [[ -z $(ip link show | grep tun) ]]; then
      if [[ -n $(ip link show | egrep "enp0s20u3u1u3|eth0") ]]; then
        sudo ip link set wlp3s0 down
      fi
      sendmessage "Connecting to $url"
      if [[ $conn_type == "OpenVPN" ]]; then
        screen -dmS vpn launchopenvpn.exp "$url" "$username" "$password"
      else
        screen -dmS vpn launchvpn.exp $url $username $password $2fa
      fi
      while [[ -z $(ip link show | grep tun) ]] && [[ $time -le $timeout ]]; do
        sleep 1 && echo -n "."
        time=$((time+1))
      done
      while [[ -n $(ip link show | grep tun) ]]; do
        yad --notification --image vpn --text "VPN connected: $url" --command="" --menu 'Disconnect!vpn.sh stop'
      done > /dev/null 2>&1 &
      if [[ $time -le $timeout ]]; then
        sendmessage "Connected to VPN"
      else
        sudo pkill openconnect
        sudo pkill openvpn
        sendmessage "Connection timed out. Operation aborted."
        sudo ip link set wlp3s0 up
      fi
    else
      sendmessage "tun network device already exists. Is the VPN already running?"
    fi
    ;;
  stop)
    sudo pkill openconnect
    sudo pkill openvpn
    pkill yad
    sudo resolvconf -d tun0
    sudo ip link set wlp3s0 up
    sudo dhcpcd wlp3s0
    sendmessage "VPN connection stopped"
    ;;
  *)
    echo "Usage: vpn (start|stop)"
esac
