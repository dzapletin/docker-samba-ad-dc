#!/bin/sh

set -e

if [ $MODE = 'BDC' ]; then

    echo "*/15 * * * * /sync-sysvol.sh" > /etc/cron.d/samba

fi