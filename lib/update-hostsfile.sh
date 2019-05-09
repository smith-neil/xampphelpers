#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--hostname)
    SITE_HOSTNAME="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--ip)
    IP="$2"
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


# check arguments, assign defaults, and exit if needed
if [ -z "$SITE_HOSTNAME" ]
then
    echo "\$SITE_HOSTNAME is empty"
    exit 1
fi
if [ -z "$IP" ]
then
    IP=127.0.0.1
fi

echo "${IP}     ${SITE_HOSTNAME}" | sudo tee -a /etc/hosts
echo "::1     ${SITE_HOSTNAME}" | sudo tee -a /etc/hosts
