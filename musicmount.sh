#!/bin/bash

fusermount -uz ~/Music
sshfs kray:/media/storage/data/media/files/Music ~/Music -o reconnect,ServerAliveInterval=5,ServerAliveCountMax=1
