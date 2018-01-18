#!/bin/bash



export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

function get_server_num() {
  echo $(echo $DISPLAY | sed -r -e 's/([^:]+)?:([0-9]+)(\.[0-9]+)?/\2/')
}

SELENIUM_PORT=4444;

if [[ "${NUM_OF_SELENIUMS}" != "" ]]; then
else
   NUM_OF_SELENIUMS=1;
fi

#we don't want to see the output we just want these to be up. 
for (( port=4444; port<$NUM_OF_SELENIUMS; port++))
do
xvfb-run --auto-servernum --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" \
  java -jar /opt/selenium/selenium-server-standalone.jar \
  -port $port > /dev/null 2>&1 &
done