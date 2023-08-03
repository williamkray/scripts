#!/bin/bash

fusermount -uz ~/Music
sshfs home:/mnt/apps/storage/media/music ~/Music -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=1
