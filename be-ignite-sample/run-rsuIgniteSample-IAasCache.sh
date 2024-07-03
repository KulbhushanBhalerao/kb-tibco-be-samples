#!/bin/bash

BE_HOME="/opt/tibco/be/be/6.3/"
CDD="/Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsu-ignite-sample/Deployments/rsuIgniteSample.cdd"
EAR="/Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsuIgniteSample.ear"
TRA="$BE_HOME/bin/be-engine.tra"

name="IAactAsCacheServer"
PU="default"

echo "Running $name"
cd $BE_HOME/bin/
./be-engine --propFile "$TRA" -u "$PU" -c "$CDD" "$EAR" -n "$name"

echo "Done $name"

#Pause
read -p "Press [Enter] key to continue..."