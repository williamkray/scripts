#!/bin/bash

fusermount -uz ~/Music
sshfs kray:/mnt/media/music ~/Music -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=1
