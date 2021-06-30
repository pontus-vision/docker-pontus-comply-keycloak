#!/bin/bash

cd /mnt/keycloak 

if [[ (! -d /mnt/keycloak/jboss)  || ("true" = "${PV_FORCE_REINSTALL}" ) ]]; then 

  echo "#####  REMOVING old JBOSS folder"
  rm -rf /mnt/keycloak/jboss || true
  echo "#####  CREATING new JBOSS folder"
  tar xfz /opt/jboss.tar.gz 
#tar xfz /opt/jboss/keycloak/standalone.tar.gz
#cp -a /opt/jboss/keycloak/standalone/* /mnt/keycloak/
  echo "####  CREATING sym link /opt/jboss"

fi
#SECRETS=$(aws secretsmanager get-secret-value --secret-id test1/pv/admin | jq -r '.SecretString')
#echo "AFTER GETTING SECRETS"

#KEYCLOAK_USER=$(echo $SECRETS | jq -r '.KEYCLOAK_USER')
#KEYCLOAK_PASSWORD=$(echo $SECRETS | jq -r '.KEYCLOAK_PASSWORD')
#export KEYCLOAK_USER=${KEYCLOAK_USER:-admin}
#export KEYCLOAK_PASSWORD=${KEYCLOAK_PASSWORD:-adminpa55word}
#echo "AFTER GETTING USER/PASS"

#export KEYCLOAK_USER_FILE=/mnt/keycloak/KEYCLOAK_USER
#echo ${KEYCLOAK_USER} > ${KEYCLOAK_USER_FILE}

#export KEYCLOAK_PASSWORD_FILE=/mnt/keycloak/KEYCLOAK_PASSWORD
#echo ${KEYCLOAK_PASSWORD} > ${KEYCLOAK_PASSWORD_FILE}
#echo "AFTER CREATING FILES USER/PASS"

#export JBOSS_BASE_DIR=/mnt/keycloak/standalone
echo "##### about to start keycloak"
/opt/jboss/tools/docker-entrypoint.sh "$@"
