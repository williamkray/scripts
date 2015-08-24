#!/bin/bash

fusermount -uz ~/Music
sshfs kray:/media/storage/media/music ~/Music -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=1
