#!/bin/sh

set -e

ME=$(basename "$0")

if [ ! "$(ls -A /var/lib/samba/private)" ]; then

    if [ $MODE = 'BDC' ]; then
        echo "$ME: Joining domain..."
        
        /usr/bin/samba-tool domain join $REALM DC --server=$PDC_IP --site=$SITE \
                             --dns-backend=BIND9_DLZ \
                             --option='idmap_ldb:use rfc2307 = yes' --option="interfaces=127.0.0.1 $HOST_IP" --option="bind interfaces only=yes" \
                             -U $(cat /run/secrets/domain_user) --password=$(cat /run/secrets/domain_password)

        net cache flush
        
        # Sync Sysvol to the new DC
        /sync-sysvol.sh

        # Reset the Sysvol folder's file system access control lists (ACL)
        /usr/bin/samba-tool ntacl sysvolreset
    else
        echo "$ME: Provisioning domain..."
        
        /usr/bin/samba-tool domain provision --server-role=dc --realm=$REALM --domain=$DOMAIN --site=$SITE \
                             --use-rfc2307 --dns-backend=BIND9_DLZ \
                             --option="interfaces=127.0.0.1 $HOST_IP" --option="bind interfaces only=yes" \
                             --adminpass=$(cat /run/secrets/domain_password)
    fi

    # Adjust permissions
    # Bind
    chown root:bind /var/lib/samba/bind-dns
    chmod 770 /var/lib/samba/bind-dns
    chown root:bind /var/lib/samba/bind-dns/dns.keytab
    chmod 640 /var/lib/samba/bind-dns/dns.keytab
    # Chrony
    chown root:_chrony /var/lib/samba/ntp_signd
    chmod 750 /var/lib/samba/ntp_signd

else
    echo "$ME: Domain controller already provisioned"
fi