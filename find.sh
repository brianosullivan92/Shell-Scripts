#!/bin/bash
# find.sh - find all files that end in the file formats below
# s is for server and f is for file format
for s in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30;	
do

    LOG_FILE="/var/log/fdc/music_server$s.log"
    echo " Searching in /media/usbdrive/server$s/home/* ..."						>> "${LOG_FILE}"
    
    echo ""									>> "${LOG_FILE}"
    for f in  wav m4a wma mp3 mp4 wma aac mpc 3gp avi flv fla m4v m1v m2v mov wmv;
    do
    echo " Searching for *.$f files..."						>> "${LOG_FILE}"
    echo ""									>> "${LOG_FILE}"
    find /media/usbstick/server$s/home/ -type f -name *.$f			>> "${LOG_FILE}"
    echo ""									>> "${LOG_FILE}"	
    done
done

exit 0
