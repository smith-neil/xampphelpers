#!/bin/bash

# Add's a virtual host to XAMPP's httpd-vhosts.conf located at /Applications/XAMPP/etc/extra/httpd.conf
# Parameters:
# -v, --vhost
#   The name of the VirtualHost e.g. test.localhost
# -d, --documentroot
#   The path to the site e.g. /Users/dot/www/test.localhost
# -p, --port
#   The port the vhost will run on. This is optional and will run on 80 by default

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
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


# check arguments, assign defaults, and exit if needed
if [ -z "$VHOST" ]
then
    echo "\$VHOST is empty"
    exit 1
fi
if [ -z "$DOCUMENTROOT" ]
then
    echo "\$DOCUMENTROOT is empty"
    exit 1
fi
if [ -z "$PORT" ]
then
    PORT=80
fi


# update httpd-vhosts.conf
echo "
<VirtualHost ${VHOST}:${PORT}>
    DocumentRoot \"${DOCUMENTROOT}\"
    ServerName ${VHOST}
</VirtualHost>" >> /Applications/XAMPP/etc/extra/httpd-vhosts.conf