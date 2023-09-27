#!/bin/bash

set -em

#trap "exit" INT TERM ERR # on this process exit
#trap "exit" CHLD # on child process exit
#trap "kill 0" EXIT

ME=$(basename "$0")

# Start Chrony
chown -R _chrony: /run/chrony
chmod o-rx /run/chrony
rm -f /var/run/chrony/chronyd.pid
/usr/sbin/chronyd -d -x &
# Start Bind9
/usr/sbin/named -g &
# Start Samba
/usr/sbin/samba -F & # --no-process-group
# Start Rsync
if [ $MODE = 'PDC' ]; then
    /usr/bin/rsync --no-detach &
fi

# Running tests

#echo "$ME: Testing DNS..."
#host -t SRV _ldap._tcp.${REALM}.
#host -t SRV _kerberos._udp.${REALM}.
#host -t A ${HOST_FQDN}.

#echo "$ME: Getting replication status..."
#/usr/bin/samba-tool drs showrepl

#if [ $MODE = 'BDC' ]; then
#    echo "$ME: Testing sysvol replication..."
#    /sync-sysvol.sh --dry-run
#fi

fg %3