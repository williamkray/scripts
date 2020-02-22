#!/usr/bin/env bash

## functions to make using the bitwarden cli easier
## without having to remember everything

# search for items in the vault, and open it in a pager
# this prevents data leaking into tty history
bwsearch() {
  bw list items --search $@ --pretty | less
}

# get TOTP
bwotp() {
  bw get totp $1
}

# spit out a list of matches to search with uuid
# only include relevant identifiable content
bwid() {
  ids=$(bw list items --search $@ --pretty | grep '"id":' | awk -F '"' '{print $4}')
  for id in $ids ; do
    item=$(bw get item $id --pretty)
    un=$(echo "$item" | jq .login.username -r)
    name=$(echo "$item" | jq .name -r)
    echo -e "$id\t\t$name\t\t\t$un"
  done
}
