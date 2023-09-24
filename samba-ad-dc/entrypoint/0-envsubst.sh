#!/bin/sh

set -e

export HOST_NAME=`hostname`

# hosts
#envsubst < /templates/hosts > /etc/hosts

# chrony
envsubst < /templates/chrony.conf > /etc/chrony/chrony.conf
# bind
envsubst < /templates/named.conf.options > /etc/bind/named.conf.options
# Kerberos
envsubst < /templates/krb5.conf > /etc/krb5.conf