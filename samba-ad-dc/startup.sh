#!/bin/bash

set -em

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

# Start Samba
/usr/sbin/samba -i &

if [ $MODE = 'BDC' ]; then
    let SLEEPTIME=60*10 # 10 mins
    while sleep ${SLEEPTIME}; do
        /sync-sysvol.sh
    done
fi

fg %%