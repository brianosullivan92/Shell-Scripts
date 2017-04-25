#!/bin/bash
echo "Bash version ${BAH_VERSION}..."
for ip in 192.168.{1..29}.250; do
  if [ "$ip" != "192.168.30.250" ]; then
        ping -c 1 $ip > /dev/null 2>&1
        if [ $? -eq 0 ]; then
	    echo "${ip} is up"
        else
            echo "${ip} is down"
    fi
  fi
done
