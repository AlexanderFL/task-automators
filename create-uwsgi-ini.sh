#!/usr/bin/env bash

# Create a .ini file for uWSGI from a base file
# param 1: name of the new .ini file

UWSGI_BASE="/etc/uwsgi/scripts/base-uwsgi"

if [ -z ${1+x} ]; then
        echo "NGINX - Filename is unset"
        exit 1;
fi

echo "Creating uWSGI init file"

sed "s/&(name)/${1}/g" $UWSGI_BASE > /etc/uwsgi/sites/${1}.ini

sudo systemctl daemon-reload
sudo systemctl restart uwsgi

echo "uWSGI has completed"
