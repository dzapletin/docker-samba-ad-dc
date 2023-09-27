#!/bin/sh

set -e

export HOST_NAME=`hostname`

# hosts
envsubst < /templates/hosts > /etc/hosts

# chrony
envsubst < /templates/chrony.conf > /etc/chrony/chrony.conf
# bind
envsubst < /templates/named.conf.options > /etc/bind/named.conf.options
# Kerberos
envsubst < /templates/krb5.conf > /etc/krb5.conf

# Rsync
if [ $MODE = 'PDC' ]; then
    echo "$(cat /run/secrets/rsync_sysvol_user):$(cat /run/secrets/rsync_sysvol_password)" > /etc/samba/rsyncd.secret
    envsubst < /templates/rsyncd.conf > /etc/rsyncd.conf
else
    cp /run/secrets/rsync_sysvol_password /etc/samba/rsyncd.secret
    chmod 400 /etc/samba/rsyncd.secret
fi