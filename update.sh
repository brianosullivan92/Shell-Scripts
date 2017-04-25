#!/bin/bash
# Simple script to execute commands on servers to apply updates etc
# Update comments, notes, etc. 
# When the code is no longer needed remove 
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
       
#Check that the required applications are present
if [ ! -f /bin/ln ];then exit 0;fi
if [ ! -f /bin/cp ];then exit 0;fi
if [ ! -f /usr/sbin/logrotate ];then exit 0;fi
if [ ! -f /bin/mkdir ]; then exit 0;fi
if [ ! -f /bin/chmod ]; then exit 0;fi
if [ ! -f /bin/chown ]; then exit 0;fi
if [ ! -f /usr/bin/lsb_release ]; then exit 0;fi
if [ ! -f /bin/uname ]; then exit 0;fi
if [ ! -f /usr/bin/uptime ]; then exit 0;fi

#Copy new files
cp -f /usr/mjk/updates/hosts /etc/
cp -f /usr/mjk/updates/db.crm.fdc.ie /etc/bind/
cp -f /usr/mjk/updates/db.crmuat.fdc.ie /etc/bind/
cp -f /usr/mjk/updates/db.crmdev.fdc.ie /etc/bind/
cp -f /usr/mjk/updates/db.168.192 /etc/bind/
cp -f /usr/mjk/updates/db.internal.fdc.ie /etc/bind/
cp -f /usr/mjk/updates/named.conf.local /etc/bind/
cp -f /usr/mjk/updates/blacklist.zones /etc/bind/
cp -f /usr/mjk/updates/db.blockeddomains /etc/bind/
#cp -f /usr/mjk/updates/policy /etc/shorewall
#service shorewall restart
#service ipsec restart
chown -R bind:bind /etc/bind
service bind9 restart
service nscd restart
#update-rc.d ipsec disable

#A few commands to always find and delete folders that should not exists on servers
#find /home/loclusrs/ -type d -name "PROGRAMFILESROS" -exec rm -rf {} \;


#if [ -f /usr/mjk/updates/sshd_config ]; then cp -rf /usr/mjk/updates/sshd_config /etc/ssh/; fi
#if [ -f /usr/mjk/updates/ssh_config ]; then cp -rf /usr/mjk/updates/sshd_config /etc/ssh/; fi
chown root:root /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
chown root:root /etc/ssh/ssh_config
chmod 644 /etc/ssh/ssh_config
if [ -f /etc/init.d/ssh ]; then sudo /etc/init.d/ssh restart; fi

#Copy in NIS Script if missing
#if [ ! -f /etc/init.d/nis ]; then cp -f /usr/mjk/updates/nis /etc/init.d/; fi

#Copy updated Hosts file to /etc/
cp -f /usr/mjk/Hosts/hosts.nor /etc/
cp -f /usr/mjk/Hosts/hosts.red /etc/

#Copy Squid OK & Not OK Folders
if [ -f /usr/mjk/Squid/ok/domains.db ]; then 
    rm /usr/mjk/Squid/ok/domains.db
	rm /usr/mjk/Squid/ok/urls.db
fi

cp -rf /usr/mjk/Squid/ok /var/lib/squidguard/db/blacklists/
cp -rf /usr/mjk/Squid/notok /var/lib/squidguard/db/blacklists/
#cp -rf /usr/mjk/Squid/squidGuard.conf /etc/squid/

# get hostname - The Steps on Server01 and remote Servers will be different
HOSTNAME=`hostname`
#Find and delete referrences to DECRYPT
#find / -type f -name "HELP_DECRYPT.*" -exec rm -rf {} \; > /home/central/updates/info/$HOSTNAME.log
#if [ $HOSTNAME != 'server01' ]; then
	#Backup all the System Users,Groups, passwords on the local remote servers
#	awk -v LIMIT=1000 -F: '($3<LIMIT) && ($3!=65534)' /etc/passwd > /usr/mjk/Users/old/passwd.old
#	awk -v LIMIT=1000 -F: '($3<LIMIT) && ($3!=65534)' /etc/group > /usr/mjk/Users/old/group.old
#	awk -v LIMIT=1000 -F: '($3<LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /usr/mjk/Users/old/shadow.old
#	awk -v LIMIT=1000 -F: '($3<LIMIT) && ($3!=65534) {print $1.":"}' /etc/group | tee - |egrep -w -f - /etc/gshadow > /usr/mjk/Users/old/gshadow.old
#	cp -f /etc/passwd /usr/mjk/old/
#	cp -f /etc/shadow /usr/mjk/old/
#	cp -f /etc/group /usr/mjk/old/
#	cp -f /etc/gshadow /usr/mjk/old/
	#Merge System User Backup with New Non System User backup from server01
#	cat /usr/mjk/Users/old/passwd.old /usr/mjk/Users/new/passwd.mig > /usr/mjk/Users/merged/passwd.merge
#	cat /usr/mjk/Users/old/group.old /usr/mjk/Users/new/group.mig > /usr/mjk/Users/merged/group.merge
#	cat /usr/mjk/Users/old/shadow.old /usr/mjk/Users/new/shadow.mig > /usr/mjk/Users/merged/shadow.merge
#	cat /usr/mjk/Users/old/gshadow.old /usr/mjk/Users/new/gshadow.mig > /usr/mjk/Users/merged/gshadow.merge

#	cp /usr/mjk/Users/merged/passwd.merge /etc/passwd
#	cp /usr/mjk/Users/merged/group.merge /etc/group
#	cp /usr/mjk/Users/merged/shadow.merge /etc/shadow
#	cp /usr/mjk/Users/merged/gshadow.merge /etc/gshadow
		
	# Set correct Permissions on the new files
#	chown root:root /etc/passwd
#	chown root:root /etc/group
#	chown root:shadow /etc/shadow
#	chown root:shadow /etc/gshadow
		
#	chmod 644 /etc/passwd
#	chmod 644 /etc/group
#	chmod 640 /etc/shadow
#	chmod 640 /etc/gshadow
	
		
#fi
# Quick check to see how long a Sever has been up and what version kernel and Ubuntu it has
if [ ! -d /home/central/updates/info/$HOSTNAME ]; then 
	mkdir -p /home/central/updates/info/$HOSTNAME
	/usr/bin/uptime > /home/central/updates/info/$HOSTNAME/info
	/sbin/ifconfig >> /home/central/updates/info/$HOSTNAME/info
	cp -rf /etc/samba /home/central/updates/info/$HOSTNAME/
	cp -rf /etc/openvpn /home/central/updates/info/$HOSTNAME/
	cp -rf /var/log/apcupsd.status /home/central/updates/info/$HOSTNAME/
else
	/usr/bin/uptime > /home/central/updates/info/$HOSTNAME/info
	/sbin/ifconfig >> /home/central/updates/info/$HOSTNAME/info
	cp -rf /etc/samba /home/central/updates/info/$HOSTNAME/
	cp -rf /etc/openvpn /home/central/updates/info/$HOSTNAME/
	cp -rf /var/log/apcupsd.status /home/central/updates/info/$HOSTNAME/
fi
# End Users
# Clynch - PCRM - Create the scan folders to be used for alfresco
#mkdir /home/local/alfresco_scans
#mkdir /home/local/alfresco_scans/accountants
#mkdir /home/local/alfresco_scans/taxplanning
#mkdir /home/local/alfresco_scans/associates
#mkdir /home/local/alfresco_scans/hq_it
#mkdir /home/local/alfresco_scans/financialservices
#mkdir /mnt/alfresco
chmod -R 777 /home/local/alfresco_scans


if [ ! -d /home/adminphilip ]; then
    mkdir /home/adminphilip
fi
if [ ! -d /home/adminchris ]; then
    mkdir /home/adminchris
fi
if [ ! -d /home/adminjustin ]; then
    mkdir /home/adminjustin
fi
if [ ! -d /home/adminpeter ]; then
    mkdir /home/adminpeter
fi
if [ ! -d /media/provident_obmtemp ]; then
    mkdir /media/provident_obmtemp
fi

chown -R adminchris:adminchris /home/adminchris
chown -R adminphilip:adminphilip /home/adminphilip
chown -R adminjustin:adminjustin /home/adminjustin
chown -R adminpeter:adminpeter /home/adminpeter
chmod -R 2777 /home/adminchris
chmod -R 2777 /home/adminphilip
chmod -R 2777 /home/adminjustin
chmod -R 2777 /home/adminpeter
chmod -R 2777 /media/provident_obmtemp
#usermod -G adm,sudo,lpadmin -a adminchris
#usermod -G adm,sudo,lpadmin -a adminphilip
#usermod -G adm,sudo,lpadmin -a adminjustin
#usermod -G adm,sudo,lpadmin -a adminpeter


#Check if the DNS Logging is correctly linked to the /var/log/ directory
#Create the link if required
if [ ! -d /var/log/bind ];then
    ln -s /var/lib/named/var/log/bind /var/log/
fi
if [ ! -d /home/local/updates ];then
    mkdir /home/local/updates
fi

#Create the required DirSyncLogs directory in the /home/local/ for the new DirSync

if [ -d /home/local/DepartmentFactFind ]; then
    chown -R root:all9 /home/local/DepartmentFactFind
    chmod -R 2777 /home/local/DepartmentFactFind
    if [ -f /usr/mjk/updates/ClientFactFindAcc.xls ]; then
		cp  /usr/mjk/updates/ClientFactFindAcc.xls /home/local/DepartmentFactFind/
		chown -R root:all9 /home/local/DepartmentFactFind
		chmod -R 2777 /home/local/DepartmentFactFind
    fi
else
    mkdir /home/local/DepartmentFactFind
    chown -R root:all9 /home/local/DepartmentFactFind
    chmod -R 2777 /home/local/DepartmentFactFind
    if [ -f /usr/mjk/updates/ClientFactFindAcc.xls ]; then
		cp  /usr/mjk/updates/ClientFactFindAcc.xls /home/local/DepartmentFactFind/
		chown -R root:all9 /home/local/DepartmentFactFind
		chmod -R 2777 /home/local/DepartmentFactFind
    fi    
fi

if [ ! -d /home/local/DirSyncLogs ]; then
    mkdir /home/local/DirSyncLogs
    chown -R root:root /home/local/DirSyncLogs
    chmod -R 2777 /home/local/DirSyncLogs
else
    chown -R root:root /home/local/DirSyncLogs
    chmod -R 2777 /home/local/DirSyncLogs
	#rm /home/local/DirSyncLogs/DIR*
fi
#-----------------------------------------------------------------------------------------
# Tidy up /usr/mjk/updates & /home/local/updates
if [ ! -f /usr/mjk/updates/cleanup.txt ]; then
	rm -r /usr/mjk/updates/*
	rm -r /home/local/updates/*
fi
touch /usr/mjk/updates/cleanup.txt



#----------------------------------------------------------------------------------------- 
#Download Software Updates from Dropbox
if [ ! -f /usr/mjk/updates/Update2015-3.06.exe ]; then
    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/bfksvgmt8vp60eh/Update2015-3.06.exe
fi

#if [ ! -f /usr/mjk/updates/FDC_SSAP2014v1.07.exe ]; then
#   cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/5775eafuk3nry0h/FDC_SSAP2014v1.07.exe
#fi

#if [ ! -f /usr/mjk/updates/jre-8u51.exe ]; then
#   cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/8ax4b7rpmyycuuy/jre-8u51.exe
#fi

#if [ ! -f /usr/mjk/updates/ccsetup506_slim.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/wvo26uvvyg9wmd8/ccsetup506_slim.exe
#fi

#AhsayACB Installer
#if [ ! -f /usr/mjk/updates/acbwin2.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/2cpo57273ij02c2/acb-win2.exe
#fi

#CT v 2014 v 1.05
#if [ ! -f /usr/mjk/updates/CT1_2014v105.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/a1on91y1rlbg1ic/CT1_2014v105.exe
#fi

#CT v 2015 v 1.03
#if [ ! -f /usr/mjk/updates/CT1_03_2015.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/onsz8lbd97wglk9/CT1_03_2015.exe
#fi

#PT v 2015 v 1.03
#if [ ! -f /usr/mjk/updates/PT1_03_2015.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/1eiu7vb7w8iss5o/PT1_03_2015.exe
#fi

#PT v 2015 v 1.04
#if [ ! -f /usr/mjk/updates/PT1.4_2015.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/f9n482csobn2mez/PT1.4_2015.exe
#fi

# Sage Accounts Production v11_3
#if [ ! -f /usr/mjk/updates/SAPv11_3.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/qm6phhlzk3rol7r/SAPv11_3.exe
#fi

# Firefox38
#if [ ! -f /usr/mjk/updates/Firefox38.exe ]; then
#    cd /usr/mjk/updates ;wget --no-check-certificate https://www.dropbox.com/s/690w9wg9q51t0bh/Firefox38.exe
#fi

# End of Software Update Downloads
#-----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------- 
# Copy downloaded software to local updates folder if not already there

if [ ! -f /home/local/updates/Update2015-3.06.exe ]; then
	cp /usr/mjk/updates/Update2015-3.06.exe /home/local/updates/Update2015-3.06.exe
fi

#if [ ! -f /home/local/updates/acbwin2.exe ]; then
#	cp /usr/mjk/updates/acbwin2.exe /home/local/updates/acbwin2.exe
#fi
#
#if [ ! -f /home/local/updates/ ]; then
#	cp /usr/mjk/updates/acbwin2.exe /home/local/updates/acbwin2.exe
#fi

#if [ ! -f /home/local/updates/Firefox38.exe ]; then
#	cp /usr/mjk/updates/Firefox38.exe /home/local/updates/Firefox38.exe
#fi

#if [ ! -f /home/local/updates/jre-8u51.exe ]; then
#	cp /usr/mjk/updates/jre-8u51.exe /home/local/updates/jre-8u51.exe
#fi

#if [ ! -f /home/local/updates/ccsetup506_slim.exe ]; then
#	cp /usr/mjk/updates/ccsetup506_slim.exe /home/local/updates/ccsetup506_slim.exe
#fi

#if [ ! -f /home/local/updates/CT1_2014v105.exe ]; then
#	cp /usr/mjk/updates/CT1_2014v105.exe /home/local/up#dates/CT1_2014v105.exe
#fi

#if [ ! -f /home/local/updates/CT1_03_2015.exe ]; then
#	cp /usr/mjk/updates/CT1_03_2015.exe /home/local/updates/CT1_03_2015.exe
#fi

#if [ ! -f /home/local/updates/PT1_03_2015.exe ]; then
#	cp /usr/mjk/updates/PT1_03_2015.exe /home/local/updates/PT1_03_2015.exe
#fi

#if [ ! -f /home/local/updates/PT1.4_2015.exe ]; then
#	cp /usr/mjk/updates/PT1.4_2015.exe /home/local/updates/PT1.4_2015.exe
#fi

#if [ ! -f /home/local/updates/SAPv11_3.exe ]; then
#	cp /usr/mjk/updates/SAPv11_3.exe /home/local/updates/SAPv11_3.exe
#fi

# End of Software Copies
#-----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------- 
# Delete any old software no longer needed
if [ -f /home/local/updates/FDC_SSAP_2014v1.04_1.exe ]; then
	rm /home/local/updates/FDC_SSAP_2014v1.04_1.exe
	rm /usr/mjk/updates/FDC_SSAP_2014v1.04_1.exe
fi
if [ -f /home/local/updates/FDC_SSAP_2014v1.04.exe ]; then
	rm /home/local/updates/FDC_SSAP_2014v1.04.exe
	rm /usr/mjk/updates/FDC_SSAP_2014v1.04.exe
fi
if [ -f /home/local/updates/ccsetup504_slim.exe ]; then
	rm /home/local/updates/ccsetup504_slim.exe
fi
if	[ -f /usr/mjk/updates/ccsetup504_slim.exe ]; then
	rm /usr/mjk/updates/ccsetup504_slim.exe
fi
if	[ -f /usr/mjk/updates/Firefox_Setup_34_0_5.exe ]; then
	rm /home/local/updates/Firefox_Setup_34_0_5.exe
	rm /usr/mjk/updates/Firefox_Setup_34_0_5.exe
fi


if [ -f /usr/mjk/CommsRpr.bin ]; then
	rm /usr/mjk/CommsRpr.bin
fi
	
if [ -f /home/local/updates/java8_25.exe ]; then
	rm /home/local/updates/java8_25.exe
	rm /usr/mjk/updates/java8_25.exe
fi
if [ -f /home/local/updates/FDC_SSAP_2014v2.01.exe ]; then
	rm /home/local/updates/FDC_SSAP_2014v2.01.exe
	rm /usr/mjk/updates/FDC_SSAP_2014v2.01.exe
fi

if [ -f /home/local/updates/FDC_SSAP_2014v2.02_Update.exe ]; then
	rm /home/local/updates/FDC_SSAP_2014v2.02_Update.exe
	rm /usr/mjk/updates/FDC_SSAP_2014v2.02_Update.exe
fi
if	[ -f /usr/mjk/updates/CT1_2014v105.exe.3 ]; then
	rm /usr/mjk/updates/CT1_2014v105.exe.3
fi
if [ -f /home/local/updates/FDC_SSAP_2014v2.02_Update_23_02_15.exe ]; then
	rm /home/local/updates/FDC_SSAP_2014v2.02_Update_23_02_15.exe
	rm /usr/mjk/updates/FDC_SSAP_2014v2.02_Update_23_02_15.exe
fi	
if  [ -f /usr/mjk/updates/ccsetup503_slim.exe ]; then
	rm /usr/mjk/updates/ccsetup503_slim.exe
	rm /home/local/updates/ccsetup503_slim.exe
fi
if [ -f /home/local/updates/PT_2014v301.exe ]; then
	rm /home/local/updates/PT_2014v301.exe
	rm /usr/mjk/updates/PT_2014v301.exe
fi	
if [ -f /home/local/updates/Already_updated_PT2015v101.bat ]; then
	rm /usr/mjk/updates/Already_updated_PT2015v101.bat
	rm /home/local/updates/Already_updated_PT2015v101.bat
fi

##### Ahsay Linux Update
#/etc/init.d/obmaua stop
#/etc/init.d/obmscheduler stop
#mv /usr/local/obm /usr/local/obm_old
#mkdir /usr/local/obm
#cp /usr/mjk/updates/obm-nix.tar.gz /usr/local/obm
#cd /usr/local/obm
#gunzip obm-nix.tar.gz
#tar -xf obm-nix.tar
#./bin/install.sh
#/etc/init.d/obmaua start
#/etc/init.d/obmscheduler start
rm -rf /usr/local/obm_old
#####End Ahsay######




# End of Delete
#-----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------- 
# Set permissions on the Updates Folder
chmod -R 2777 /home/local/updates
if [ $HOSTNAME == 'server01' ]; then chmod -R 2777 /home/central/updates; fi

#Copy updated Hosts file to /etc/
cp -f /usr/mjk/Hosts/hosts.nor /etc/
cp -f /usr/mjk/Hosts/hosts.red /etc/

#Copy Mass Squid OK & Not OK Folders
cp -rf /usr/mjk/Squid/ok /var/lib/squidguard/db/blacklists/
cp -rf /usr/mjk/Squid/notok /var/lib/squidguard/db/blacklists/

#Run NTPDate to update the Time
ntpdate ntp.ubuntu.com

# CJL - ProvidentCRM - 29/07/2015
# Push out and prepare install of OBM online backups
chown -R root:root /usr/mjk/
chmod -R 2777 /usr/mjk/
#if [ ! -d /usr/local/obm  ]; then
#    mkdir /usr/local/obm
#fi

#if [ ! -d /media/provident_obmtemp ]; then
#    mkdir /media/provident_obmtemp
#fi

#if [ -f /usr/mjk/updates/obm-nix.tar.gz ]; then
#    gunzip /usr/mjk/updates/obm-nix.tar.gz
#fi
#if [ -f /usr/mjk/updates/obm-nix.tar.gz ]; then
#   cp /usr/mjk/updates/obm-nix.tar.gz /usr/local/obm
#fi
#if [ -f /usr/local/obm/obm-nix.tar.gz ]; then
#   cd /usr/local/obm
#   tar -xzvf obm-nix.tar.gz
#fi
#ln -sf /usr/local/obm/jre64/ /usr/local/obm/jvm



#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#Chris Lynch - 26/01/2011 => Update the scriptupdate.sh file on all servers
#Update scriptupdate.sh
if [ -f /home/central/updates/ServerUpdates/scriptupdate.sh ]; then
    cp /home/central/updates/ServerUpdates/scriptupdate.sh /usr/mjk
fi
	
