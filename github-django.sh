#!/bin/bash

# Clone a github repository containing a Django project and it will automatically set it up
# Prerequisites: 'virtualenvwrapper', 'nginx', 'uwsgi'


if [ -z ${1+x} ]; then
        echo "Github repo name is missing"
        exit 1;
fi

GITHUB_ACCOUNT="https://github.com/AlexanderFL"
CLONE_LOCATION="/var/www"
VENV_LOCATION="~/Env"
REPO_NAME=$1

# Virtual environment
if [ -d "$VENV_LOCATION/$1" ]; then
        echo "Virtualenv already exists"
        echo "Skipping..."
else
        source `which virtualenvwrapper.sh`
        mkvirtualenv $REPO_NAME
        workon $REPO_NAME
fi



if [ -d "/var/www/$REPO_NAME" ]; then
        echo "Project files already exists"
else
        # Clone github repo
        git clone $GITHUB_ACCOUNT/$REPO_NAME $CLONE_LOCATION/$REPO_NAME
fi

if [[ $? -ne 0 ]]; then
        echo "Need github authentication"
        exit 1;
fi

# Install any python requirements if they exists in folder
if [ -f "$CLONE_LOCATION/$REPO_NAME/requirements.txt" ]; then
        pip install -r /var/www/$1/requirements.txt
fi

# uWSGI configuration
if [ -f "/etc/uwsgi/sites/$REPO_NAME.ini" ]; then
        echo "uWSGI ini file '$REPO_NAME.ini' already exists"
        echo "Skipping..."
else
        source /etc/uwsgi/scripts/create-uwsgi-ini.sh $REPO_NAME
fi

# Nginx configuration
if [ -f "/etc/nginx/sites-available/$REPO_NAME" ]; then
        echo "Nginx configuration file '$REPO_NAME' already exists"
        echo "Skipping"
else
        source /etc/nginx/scripts/create-django-site.sh $REPO_NAME
fi
