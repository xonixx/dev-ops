#!/usr/bin/env bash

SCRIPT_LOCATION=$(dirname "$0")
HOSTS=$(printf %s "$(cat $SCRIPT_LOCATION/cml_cert_hosts.txt)" | tr '\n' ',')
#echo $HOSTS

echo
echo
echo "--- [$(date)] renewing cert ---"

sudo service apache2 stop
sudo service haproxy stop
sudo letsencrypt certonly -t -n -vv --expand --force-renewal --standalone --domains $HOSTS
FOLD=$(sudo ls -1 -t /etc/letsencrypt/live/ | head -n 1)
echo FOLD=$FOLD
sudo bash -c "cat /etc/letsencrypt/live/$FOLD/fullchain.pem /etc/letsencrypt/live/$FOLD/privkey.pem > /etc/haproxy/a.cmlteam.com.pem"
sudo service apache2 start
sudo service haproxy start
