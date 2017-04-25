#!/bin/bash

#***********************************************************************
# Simple Wrapper script to manage update of Custom FDC Scripts and Lib *
#***********************************************************************
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
# VERSION CONTROL
# 1.0 - 27/01/2010 - BOS - Initial Build
# 1.1 - 17/05/2013 - BOS - User/Group and Passwrod Backups/Merge for Remote Servers - Server01 Backups are carried out in ScriptUpdate.sh
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------        

#assume that your sources are in /src
  cd /tmp
  wget http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz
  #download all patches
  for i in $(seq -f "%03g" 0 25); do wget     http://ftp.gnu.org/gnu/bash/bash-4.3-patches/bash43-$i; done
  tar zxvf bash-4.3.tar.gz 
  cd bash-4.3
  #apply all patches
  for i in $(seq -f "%03g" 0 25);do patch -p0 < ../bash43-$i; done
  #build and install
  ./configure && make && make install