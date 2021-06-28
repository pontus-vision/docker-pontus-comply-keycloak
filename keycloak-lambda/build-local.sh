#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

${JBOSS_HOME}/bin/standalone.sh -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=/tmp/keycloak.export.json -Dkeycloak.migration.strategy=OVERWRITE_EXISTING -Dkeycloak.profile.feature.upload_scripts=enabled &
KCPID=$!
sleep 40
kill -15 $KCPID
wait 
