#!/usr/bin/env bash

SCRIPT_LOCATION="$(dirname "$0")"
HOSTS=$(printf '%s' "$(cat $SCRIPT_LOCATION/certbot_domains.txt)" | tr '\n' ',')
#echo $HOSTS

echo
echo
echo "--- [$(date)] renewing cert ---"

sudo service nginx stop
sudo service haproxy stop

sudo certbot --agree-tos --email 'xonixx@gmail.com' \
  certonly -t --non-interactive -vv \
    --expand --force-renewal --standalone \
    --domains $HOSTS

live='/etc/letsencrypt/live'
FOLD=$(sudo ls -1 -t "$live/" | head -n 1)
echo FOLD=$FOLD
sudo bash -c "cat $live/$FOLD/fullchain.pem $live/$FOLD/privkey.pem > /etc/haproxy/maximullaris.com.pem"

sudo service nginx start
sudo service haproxy start
