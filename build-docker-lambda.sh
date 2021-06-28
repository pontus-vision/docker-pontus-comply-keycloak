#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e 
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

export DOLLAR='$'
cat $DIR/keycloak-lambda/Dockerfile.template | envsubst > $DIR/keycloak-lambda/Dockerfile
cd $DIR/keycloak-lambda

if [[ -z $FORMITI_DEV_ACCOUNT ]]; then
  docker build --rm . -t pontusvisiongdpr/pontus-comply-keycloak-lambda:${TAG}
  docker push pontusvisiongdpr/pontus-comply-keycloak-lambda:${TAG}
else 
  if [[ $(aws --version 2>&1 ) == "aws-cli/1"* ]] ; then
    $(aws ecr get-login --no-include-email --region eu-west-2)
  else
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com
  fi

  docker build --rm . -t pontus-comply-keycloak-lambda:${TAG}
  TIMESTAMP=$(date +%y%m%d_%H%M%S)
  docker tag pontus-comply-keycloak-lambda:${TAG} ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG}-${TIMESTAMP}  
  docker push ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG}-${TIMESTAMP}

fi


