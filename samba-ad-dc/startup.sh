#!/bin/bash

set -em

#trap "exit" INT TERM ERR # on this process exit
#trap "exit" CHLD # on child process exit
#trap "kill 0" EXIT

ME=$(basename "$0")

# Start Chrony
/usr/sbin/chronyd -d -x &
# Start Bind9
/usr/sbin/named -g &
# Start Samba
/usr/sbin/samba -F &

# Running tests

echo "$ME: Testing DNS..."

host -t SRV _ldap._tcp.${REALM}.
host -t SRV _kerberos._udp.${REALM}.
host -t A ${HOST_FQDN}.

echo "$ME: Getting replication status..."

/usr/bin/samba-tool drs showrepl

echo "$ME: Testing sysvol replication..."

/sync-sysvol.sh --dry-run

fg %3