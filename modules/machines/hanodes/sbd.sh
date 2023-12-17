#!/usr/bin/bash

sed -i '/^#*SBD_DEVICE=.*/s//SBD_DEVICE="\/dev\/disk\/azure\/scsi1\/lun0"/;
 /^#*SBD_PACEMAKER=.*/s//SBD_PACEMAKER=yes/;
 /^#*SBD_STARTMODE=.*/s//SBD_STARTMODE=always/' /etc/sysconfig/sbd 

