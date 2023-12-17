#!/usr/bin/bash

/usr/sbin/sbd -d /dev/disk/azure/scsi1/lun0 -1 60 -4 120 create

while [ ! -f /root/no_more_secrets ]
do
  sleep 5
done

/usr/sbin/crm cluster init --enable-sbd --no-overwrite-sshkey --nodes machine0,machine1 --yes
