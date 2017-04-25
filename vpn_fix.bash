#! /bin/bash
ping -c 1 -t 1 192.168.1.250 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "192.168.1.250 is up"
else
	echo "192.168.1.250 is down"
	service openvpn restart
fi