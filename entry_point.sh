#!/bin/bash

#!/usr/bin/env bash

umask 022

function get_server_num() {
  echo $(echo $DISPLAY | sed -r -e 's/([^:]+)?:([0-9]+)(\.[0-9]+)?/\2/')
}


#do a string replace for configuration files for the web root. 
if [[ "${APACHE_WEB_ROOT}" != "" ]]; then
    echo "web site will be set to ${APACHE_WEB_ROOT}"
else
    #set a default if one is not present
    APACHE_WEB_ROOT="/var/www/html"    
fi

if [[ "${LOG_LOC}" == true ]]; then 
  LOG_LOC="${APACHE_WEB_ROOT}/selenium.log"
  echo "Error log will be saved here ${LOG_LOC}"
else
  LOG_LOC="/dev/null"
  echo "No log will be saved"
fi
  
sed -i "s#<<APACHE_WEB_ROOT>>#${APACHE_WEB_ROOT}#" /etc/apache2/sites-enabled/000-default.conf
sed -i "s#%%APACHE_WEB_ROOT%%#${APACHE_WEB_ROOT}#" /etc/apache2/apache2.conf
	
	
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

if [[ "${JAVA_OPTS}" == '' ]]; then
  JAVA_OPTS="-Xms128m -Xmx512m"
fi

SELENIUM_PORT=4444;

if [[ "${NUM_OF_SELENIUMS}" != "" ]]; then
	echo "${NUM_OF_SELENIUMS} will run"
else
   NUM_OF_SELENIUMS=1;
fi

rm -f /tmp/.X*lock

SERVERNUM=$(get_server_num);

NUM_OF_SELENIUMS=$((SELENIUM_PORT + NUM_OF_SELENIUMS));
#need to change directory to apache web root so we have a direct connection and not waiting on page loads. 
cd ${APACHE_WEB_ROOT}
#we don't want to see the output we just want these to be up. 
for ((port=SELENIUM_PORT; port < NUM_OF_SELENIUMS; port++))
do
xvfb-run --auto-servernum -n ${SERVERNUM} --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
  java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  -port $port >> ${LOG_LOC} 2>&1 &
  echo "selenium is running on port: ${port} with pid $!"
done

if [[ $# -eq 1 && $1 == "bash" ]]; then
	$@;
else
	exec "$@";
fi
