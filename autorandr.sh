#!/bin/bash
#
# to crank down font size:
# xfconf-query -c xsettings -p /Xft/DPI -s 96

export DISPLAY=":0"

# set to check for nearby TEN wifi networks for work monitor setup
if [[ -n $(xrandr|grep "DP2-1 connected") && -n $(xrandr|grep "DP2-2 connected") ]]; then
#if [[ -n $(xrandr|grep "DP2-1 connected") && -n $(xrandr|grep "DP2-2 connected") && -n $(sudo iw dev wlp3s0 scan | grep "TEN-Guest") ]]; then
  while [[ -z $(xrandr|grep "Screen 0"|grep "current 6400 x 1440") || $counter < 1 ]]; do
    xrandr --output DP2-1 --right-of eDP1 --mode 1920x1080
    xrandr --output DP2-2 --right-of DP2-1 --mode 1920x1080
#    xfconf-query -c xsettings -p /Xft/DPI -s 96
    numlockx
    sudo dhcpcd enp0s20u3u1u3c2
    sudo dhcpcd eth0
    skype &
    if [[ -n $(sudo iw dev wlp3s0 scan | grep "krayhome") ]]; then
      pacmd set-default-source alsa_input.usb-Logitech_Logitech_USB_Headset-00-Headset.analog-mono
      pacmd set-default-sink alsa_output.usb-Logitech_Logitech_USB_Headset-00-Headset.analog-stereo
    else
      pacmd set-default-sink alsa_output.usb-C-Media_Electronics_Inc._ThinkPad_OneLink_Pro_Dock_Audio-00.analog-stereo
    fi
    counter=$((counter + 1))
  done
#elif [[ -n $(xrandr|grep "HDMI1 connected") && -n $(xrandr|grep "HDMI2 connected") && -n $(sudo iw dev wlp3s0 scan | grep "krayhome") ]]; then
#  while [[ -z $(xrandr|grep "Screen 0"|grep "current 6400 x 1440") || $counter < 1 ]]; do
#    xrandr --output HDMI1 --right-of eDP1 --mode 1920x1080
#    xrandr --output HDMI2 --right-of HDMI1 --mode 1920x1080
#    xfconf-query -c xsettings -p /Xft/DPI -s 96
#    numlockx
#    counter=$((counter + 1))
#  done
elif [[ -n $(xrandr|grep "DP2 connected") && -n $(xrandr|grep "3840x1080") ]]; then
  /home/william/.screenlayout/docked_wide.sh
#  xfconf-query -c xsettings -p /Xft/DPI -s 96
  numlockx
  pacmd set-default-sink alsa_output.usb-C-Media_Electronics_Inc._ThinkPad_OneLink_Pro_Dock_Audio-00.analog-stereo
  sudo dhcpcd enp0s20u3u1u3c2
  skype &
elif [[ -n $(xrandr|grep "HDMI2 connected") ]]; then
  /home/william/.screenlayout/hdmi-only.sh
else
  while [[ -z $(xrandr|grep "Screen 0"|grep "current 2560 x 1440") || $counter < 1 ]]; do
    /home/william/.screenlayout/solo.sh
#    xfconf-query -c xsettings -p /Xft/DPI -s 155
    pacmd set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    counter=$((counter + 1))
  done
fi

exit 0
