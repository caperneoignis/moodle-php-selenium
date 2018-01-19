#!/bin/bash

#!/usr/bin/env bash

umask 022

#do a string replace for configuration files for the web root. 
if [[ "${APACHE_WEB_ROOT}" != "" ]]; then
    echo "web site will be set to ${APACHE_WEB_ROOT}"
else
    #set a default if one is not present
    APACHE_WEB_ROOT="/var/www/html"    
fi

sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_WEB_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
sed -i "s#%%APACHE_WEB_ROOT%%#${APACHE_WEB_ROOT}#" /etc/apache2/apache2.conf
	
	
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function get_server_num() {
  echo $(echo $DISPLAY | sed -r -e 's/([^:]+)?:([0-9]+)(\.[0-9]+)?/\2/')
}

SELENIUM_PORT=4444;

if [[ "${NUM_OF_SELENIUMS}" != "" ]]; then
	echo "${NUM_OF_SELENIUMS} will run"
else
   NUM_OF_SELENIUMS=1;
fi
NUM_OF_SELENIUMS=$((SELENIUM_PORT + NUM_OF_SELENIUMS));
#we don't want to see the output we just want these to be up. 
for ((port=SELENIUM_PORT; port < NUM_OF_SELENIUMS; port++))
do
xvfb-run --auto-servernum --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
  java -jar /opt/selenium/selenium-server-standalone.jar \
  -port $port   &
  echo "selenium is running on port: ${port} with pid $!"
done

if [[ $# -eq 1 && $1 == "bash" ]]; then
	$@;
else
	exec "$@";
fi
