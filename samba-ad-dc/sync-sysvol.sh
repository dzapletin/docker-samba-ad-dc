#!/bin/sh

/usr/bin/cp /run/secrets/rsync_sysvol_password /etc/samba/rsyncd.secret
/usr/bin/chmod 400 /etc/samba/rsyncd.secret
/usr/bin/rsync $@ -XAavz --delete-after --password-file=/etc/samba/rsyncd.secret rsync://$(cat /run/secrets/rsync_sysvol_user)@${PDC_IP}/SysVol/ /var/lib/samba/sysvol/