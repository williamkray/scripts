#!/bin/bash

bt_connections=$(find /sys/class/bluetooth/hci0/ -type d -name hci0:* | wc -l)
echo $bt_connections
