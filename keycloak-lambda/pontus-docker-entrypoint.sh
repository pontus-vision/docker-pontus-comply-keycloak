#!/bin/bash

cd /mnt/keycloak 

if [[ (! -d /mnt/keycloak/keycloak-14.0.0)  || ("true" = "${PV_FORCE_REINSTALL}" ) ]]; then 

  echo "#####  REMOVING old folder"
  rm -rf /mnt/keycloak/jboss || true
  rm -rf /mnt/keycloak/keycloak-14.0.0 || true
  echo "#####  CREATING new folder"
  tar xfz /opt/keycloak.tar.gz 
  echo "#####  Finished CREATING new folder"
#tar xfz /opt/jboss/keycloak/standalone.tar.gz
#cp -a /opt/jboss/keycloak/standalone/* /mnt/keycloak/

fi
if [[ (! -d /mnt/keycloak/config_pv2)  || ("true" = "${PV_FORCE_RESET_ADMIN_USER}" ) ]]; then 
   rm -rf /mnt/keycloak/config* || true
   #/mnt/keycloak/keycloak-14.0.0/bin/add-user-keycloak.sh -u admin -p Adminpa55word2@
   /mnt/keycloak/keycloak-14.0.0/bin/add-user-keycloak.sh -r master -u admin -p ${PV_KEYCLOAK_ADMIN_PASSWD:-Adminpa55word2@!}
   #/mnt/keycloak/keycloak-14.0.0/bin/add-user.sh -u "admin" -p "Adminpa55word2@!" -e -g PowerUser,BillingAdmin
   mkdir /mnt/keycloak/config_pv2
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
#export JAVA_OPTS=${JAVA_OPTS_OVERRIDE:-"-Djboss.http.port=8888 -Djboss.https.port=443"}
export JAVA_OPTS=${JAVA_OPTS_OVERRIDE:-"-Djboss.http.port=8888"}
cp /opt/standalone.xml /mnt/keycloak/keycloak-14.0.0/standalone/configuration/
/mnt/keycloak/keycloak-14.0.0/bin/standalone.sh "$@"
