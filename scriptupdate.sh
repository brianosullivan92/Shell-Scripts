#!/bin/bash

#***********************************************************************
# Simple Wrapper script to manage update of Custom FDC Scripts and Lib *
#***********************************************************************
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------        

LOG_FILE="/var/log/fdc/ServerUpdates.log"

DT1=$(date "+%d/%m-%Y")
DT2=$(date "+%H:%M:%S")

if [ ! -f $LOG_FILE ]; then /usr/bin/touch /var/log/fdc/ServerUpdates.log; fi

#Begin Logging
echo "##########################################"		>> "${LOG_FILE}"
echo "    Starting Custom FDC Script Updates 	"		>> "${LOG_FILE}"
echo "	  Started $DT1 - $DT2					"		>> "${LOG_FILE}"
echo "##########################################"		>> "${LOG_FILE}"
echo ""													>> "${LOG_FILE}"
echo ""													>> "${LOG_FILE}"

# Define the location of the Source and Target Directories and check they exist
#Source Directories for the Scripts and Libs
SrcScripts=/home/central/updates/ServerUpdates/usr/mjk/

if [ -d $SrcScripts ]; then echo "$SrcScripts Directory Exists"; else echo "$SrcScripts not available"; fi	>> "${LOG_FILE}"
echo ""														>> "${LOG_FILE}"

#Target Directories for the Scripts nnd Libs
TgtScripts=/usr/mjk/

if [ -d $TgtScripts ]; then echo "$TgtScripts Directory Exists"; else echo "$TgtScripts not available"; fi	>> "${LOG_FILE}"
echo ""														>> "${LOG_FILE}"

# If on Server01 Backup the Non System Users, passwds & Groups
HOSTNAME=`hostname`
if [ $HOSTNAME = 'server01' ]; then
	awk -v LIMIT=1000 -F: '($3>=LIMIT)' /etc/passwd > $SrcScripts/Users/new/passwd.mig
	awk -v LIMIT=1000 -F: '($3>=LIMIT)' /etc/group > $SrcScripts/Users/new/group.mig
	awk -v LIMIT=1000 -F: '($3>=LIMIT) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > $SrcScripts/Users/new/shadow.mig
	awk -v LIMIT=1000 -F: '($3>=LIMIT) {print $1.":"}' /etc/group | tee - |egrep -w -f - /etc/gshadow > $SrcScripts/Users/new/gshadow.mig
fi

if [ -d /usr/mjk/Old2New ]; then
	rm -rf /usr/mjk/Old2New
fi

#Rsync Commands to copy across new/updated files
if [ -f /usr/bin/rsync ]; then
    /usr/bin/rsync -azh --stats $SrcScripts $TgtScripts					>> "${LOG_FILE}"
else
    echo "Rsync not Found"								>> "${LOG_FILE}"
fi

DT3=$(date "+%d/%m/%Y")
DT4=$(date "+%H:%M:%S")

echo ""								>> "${LOG_FILE}"
echo "###########################################"		>> "${LOG_FILE}"
echo "    Finished Custom FDC Script Updates 	 "		>> "${LOG_FILE}"
echo "	  Started $DT3 - $DT4			 "		>> "${LOG_FILE}"
echo "###########################################"		>> "${LOG_FILE}"
echo ""								>> "${LOG_FILE}"
echo ""								>> "${LOG_FILE}"
echo ""								>> "${LOG_FILE}"
