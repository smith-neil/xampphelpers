#!/bin/bash


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -v|--vhost)
    VHOST="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--documentroot)
    DOCUMENTROOT="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--port)
    PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--password)
    PASSWORD="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Stop Apache
sudo apachectl stop

# Setup Apache - Add VirtualHost and Update hosts
source ./lib/add-vhost.sh -v $VHOST -r $DOCUMENTROOT -p $PORT
source ./lib/update-hostsfile.sh -h $VHOST

# Setup Databse - Create db and user
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${VHOST//./_}'@'localhost' IDENTIFIED BY '${PASSWORD}';CREATE DATABASE ${VHOST//./_};"

# Install WordPress
wp core download --path=$DOCUMENTROOT && cd $DOCUMENTROOT

# Setup WordPress config
wp config create --dbname=${VHOST//./_} --dbuser=${VHOST//./_} --dbpass=${PASSWORD}
rm ${DOCUMENTROOT}/wp-config-sample.php

# Restart Apache
sudo apachectl start
