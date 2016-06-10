#!/bin/bash

input="$1"
cookbook=`echo "$input" | sed 's/^cookbooks\///'|sed 's/\/metadata.rb$//'`

#echo $cookbook
metadata.sh $cookbook
