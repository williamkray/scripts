#!/bin/bash
running=$(ps ax | grep rssdler | grep -v grep)

if [[ -z $running ]] ; 
    then   
    /usr/bin/python2 /usr/bin/rssdler --purge-failed
    /usr/bin/python2 /usr/bin/rssdler -d
fi
