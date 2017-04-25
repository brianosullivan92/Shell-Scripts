#!/bin/bash
# Script to restart IPSEC

pattern1="192.168.1.0"

# Check if /media/backup is mounted
if route|grep "$pattern1";then
    echo "Route Up"
else
    echo "Route Down"
    service ipsec stop
    service ipsec start
fi

exit 0
