#!/bin/bash
# Simple script to enable IPSEC and disable OPenVPN
# Backup Shorewall and OPenVPN also

backup_files="/etc/shorewall /etc/openvpn"
dest="/home/adminchris"
day=$(date +%Y-%m-%d:%H:%M)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"
# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo
# Backup the files using tar.
tar czf $dest/$archive_file $backup_files
# Print end status message.
echo
echo "Backup finished"
date

echo 
echo "Copy new Shorewall File"
cp -r /usr/mjk/updates/OpenSwan/Firewall/PPP/shorewall/* /etc/shorewall/
echo "Restart Shorewall"
service shorewall restart
echo "Enable IPSEC"
update-rd.d ipsec enable
echo "Disable OpenVPN" 
update-rd.d ipsec disable
echo "Stop OpenVPN"
service openvpn stop
echo "Start OpenSwan"
service ipsec start
echo "Restarting Autofs & NFS"
service nfs-kernel-server restart
service autofs restart
echo
echo
echo "Test VPN is up and you can ping server01"
echo "Test that you can ls -l /home/central/*"
echo "That that you can ls -l /home/centusrs/*"
pause



