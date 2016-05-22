#!/bin/bash

bt_connections=$(hcitool con)

echo "$bt_connections"|grep -iv connections | awk '{print $3}'|wc -l
