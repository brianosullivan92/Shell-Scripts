#!/bin/bash
# Alfresco Sync - Brian O' Sullivan - 
#
#
# Script used to sync scanned files to alfresco
# TODO: Add logic to detect server and set correct locations
#

LOG_FILE="/var/log/fdc/Alfresco.log"
DIR_ACC="/home/local/alfresco_scans/accountants/"
DIR_TXP="/home/local/alfresco_scans/taxplanning/"
DIR_ASC="/home/local/alfresco_scans/associates/"
DIR_FNS="/home/local/alfresco_scans/financialservices/"
DIR_HQ="/home/local/alfresco_scans/hq_it/"
# Get Office based on hostname
HOSTNAME=`hostname`

if [ $HOSTNAME == "server01" ]; then Office="Cork"; fi
if [ $HOSTNAME == "server02" ]; then Office="Kanturk"; fi
if [ $HOSTNAME == "server03" ]; then Office="Kilmallock"; fi
if [ $HOSTNAME == "server04" ]; then Office="Newcastlewest"; fi
if [ $HOSTNAME == "server05" ]; then Office="Limerick"; fi
if [ $HOSTNAME == "server06" ]; then Office="Carlow"; fi
if [ $HOSTNAME == "server07" ]; then Office="Tullow"; fi
if [ $HOSTNAME == "server08" ]; then Office="DungarvanV"; fi
if [ $HOSTNAME == "server09" ]; then Office="DungarvanM"; fi
if [ $HOSTNAME == "server10" ]; then Office="Skibbereen"; fi
if [ $HOSTNAME == "server11" ]; then Office="Bandon"; fi
# if [ $HOSTNAME == "server12" ]; then Office="Abbeyfeale"; fi
if [ $HOSTNAME == "server13" ]; then Office="NewRoss"; fi
if [ $HOSTNAME == "server14" ]; then Office="Cashel"; fi
if [ $HOSTNAME == "server15" ]; then Office="Waterford"; fi
if [ $HOSTNAME == "server16" ]; then Office="Millstreet"; fi
if [ $HOSTNAME == "server17" ]; then Office="Kilkenny"; fi
if [ $HOSTNAME == "server18" ]; then Office="Roscrea"; fi
if [ $HOSTNAME == "server19" ]; then Office="Carrick"; fi
if [ $HOSTNAME == "server20" ]; then Office="Cahir"; fi
if [ $HOSTNAME == "server21" ]; then Office="Tralee"; fi
if [ $HOSTNAME == "server22" ]; then Office="Listowel"; fi
if [ $HOSTNAME == "server23" ]; then Office="Lismore"; fi
if [ $HOSTNAME == "server24" ]; then Office="Mallow"; fi
if [ $HOSTNAME == "server25" ]; then Office="Fermoy"; fi
if [ $HOSTNAME == "server26" ]; then Office="Ennis"; fi
if [ $HOSTNAME == "server27" ]; then Office="Midleton"; fi
if [ $HOSTNAME == "server28" ]; then Office="Bantry"; fi
if [ $HOSTNAME == "server29" ]; then Office="Foynes"; fi

if [ $Office == "Skibbereen" ]; then

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib1/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib1/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib1/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib1/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib1/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib2/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib2/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib2/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib2/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/skib2/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"
fi


if [ $Office == "Limerick" ]; then

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick1/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick1/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick1/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick1/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick1/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick2/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick2/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick2/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick2/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/limerick2/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"
fi



if [ $Office == "Midleton" ]; then

		rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton1/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton1/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton1/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton1/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton1/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton2/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton2/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton2/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton2/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/Midleton2/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"
		
fi




if [ $Office != "Cork" ] && [ $Office != "Skibbereen" ] && [ $Office != "Limerick" ] && [ $Office != "Midleton" ]; then

        rsync -azhv --stats --remove-source-files $DIR_ACC /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files $DIR_ASC /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files $DIR_TXP "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files $DIR_FNS "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files $DIR_HQ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"
fi



if [ $Office == "Cork" ]; then

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/asc_scanner/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/asc_scanner/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/asc_scanner/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/asc_scanner/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/asc_scanner/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/fns_scanner/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/fns_scanner/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/fns_scanner/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/fns_scanner/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/fns_scanner/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth1_scanner/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth1_scanner/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth1_scanner/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth1_scanner/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth1_scanner/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth2_scanner/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth2_scanner/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth2_scanner/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth2_scanner/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/sth2_scanner/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"

        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/txp_scanner/accountants/ /mnt/alfresco/Shared/Scanners/$Office/Accountants/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/txp_scanner/associates/ /mnt/alfresco/Shared/Scanners/$Office/Associates/  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/txp_scanner/taxplanning/ "/mnt/alfresco/Shared/Scanners/$Office/Tax Planning/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/txp_scanner/financialservices/ "/mnt/alfresco/Shared/Scanners/$Office/Financial Services/"  >> "${LOG_FILE}"
        rsync -azhv --stats --remove-source-files /home/local/alfresco_scans/txp_scanner/hq_it/ "/mnt/alfresco/Shared/Scanners/$Office/HQ & IT/"  >> "${LOG_FILE}"
fi

exit
