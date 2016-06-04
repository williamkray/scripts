#!/bin/bash

oathtool -b --totp "$1" | xclip -i -selection clipboard
echo "One Time Password copied to clipboard!"
