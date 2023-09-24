#!/bin/sh

/usr/bin/rsync $@ -XAavz --delete-after --password-file=/run/secrets/rsync_sysvol_password rsync://$(cat /run/secrets/rsync_sysvol_user)@${PDC_IP}/SysVol/ /var/lib/samba/sysvol/