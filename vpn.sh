#!/bin/bash

time=0
timeout=30

function sendmessage() {
  local msg="$1"
  echo -ne "$msg" && notify-desktop -r $(cat /tmp/vpn-id) "$msg" > /tmp/vpn-id
}

case "$1" in
  start)
    string=$(yad --center --title "VPN Connector" --image "vpn" --text "VPN connection info" --form --field="URL/file" --field="Username" --field="Password":H --field="Connection Type ":CB "/home/william/Projects/protonvpn/us-01.protonvpn.com.udp1194.ovpn" "" "" "Cisco (OpenConnect)!^OpenVPN" --field="2FA")

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
        sudo ip link set wlp4s0 down
      fi
      sendmessage "Connecting to $url"
      if [[ $conn_type == "OpenVPN" ]]; then
        sendmessage "\nUsing OpenVPN"
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
        sendmessage "\nConnected to VPN\n"
      else
        sudo pkill openconnect
        sudo pkill openvpn
        sendmessage "Connection timed out. Operation aborted.\n"
        sudo ip link set wlp4s0 up
      fi
    else
      sendmessage "tun network device already exists. Is the VPN already running?\n"
    fi
    ;;
  stop)
    sudo pkill openconnect
    pkill yad
    sudo resolvconf -d tun0
    sudo ip link set wlp4s0 up
    sudo dhcpcd wlp4s0
    sendmessage "VPN connection stopped\n"
    ;;
  *)
    echo "Usage: vpn (start|stop)"
esac
