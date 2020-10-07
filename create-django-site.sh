#!/usr/bin/env bash

# Create a nginx configuration file from a base template
# param 1: name of the configuration file

BASE_TEMPLATE="/etc/nginx/scripts/base-django"

if [ -z ${1+x} ]; then
        echo "NGINX - Filename is unset"
        exit 1;
fi

sed "s/&(name)/${1}/g" $BASE_TEMPLATE > /etc/nginx/sites-available/${1}
sudo nginx -t

if [[ $? -ne 0 ]]; then
        echo "Something went wrong"
        exit 1;
fi

sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled

sudo systemctl restart nginx
