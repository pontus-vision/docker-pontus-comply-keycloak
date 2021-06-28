#!/bin/bash

cd /mnt/keycloak 
tar xfz /opt/jboss/keycloak/standalone.tar.gz
#cp -a /opt/jboss/keycloak/standalone/* /mnt/keycloak/

export JBOSS_BASE_DIR=/mnt/keycloak/standalone
/opt/jboss/tools/docker-entrypoint.sh "$@"
