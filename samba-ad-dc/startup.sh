#!/bin/bash

set -e

#trap "exit" INT TERM ERR # on this process exit
#trap "exit" CHLD # on child process exit
#trap "kill 0" EXIT

ME=$(basename "$0")

# Start Chrony
rm -f /var/run/chrony/chronyd.pid
/usr/sbin/chronyd -d -x &

# Start Bind9
/usr/sbin/named -g &

# Start Rsync
if [ $MODE = 'PDC' ]; then
    /usr/bin/rsync --no-detach &
fi

# Start Cron
if [ $MODE = 'BDC' ]; then
    /usr/sbin/cron -f &
fi

# Start Samba
/usr/sbin/samba -i