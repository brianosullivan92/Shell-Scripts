#/bin/sh

#Brian O Sullivan - quick script that will run every 60 seconds and log the output of top and other commands.


uptime >> /home/adminchris/uptime.log;
top -b -n1 >> /home/adminchris/top.log;
exit

