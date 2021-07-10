#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e 
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

export DOLLAR='$'
cat $DIR/keycloak-lambda/Dockerfile.template | envsubst > $DIR/keycloak-lambda/Dockerfile
cd $DIR/keycloak-lambda
export KEYCLOAK_USER=${KEYCLOAK_USER:-admin}
export KEYCLOAK_PASSWORD=${KEYCLOAK_PASSWORD:-adminpa55word2}

echo "$KEYCLOAK_PASSWORD" > KEYCLOAK_PASSWORD_FILE
echo "$KEYCLOAK_USER" > KEYCLOAK_USER_FILE

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
  #docker tag pontus-comply-keycloak-lambda:${TAG} ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG}-${TIMESTAMP}  
  docker tag pontus-comply-keycloak-lambda:${TAG} ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG}
  docker push ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG}
#  IMAGE_SHA=$(docker images --no-trunc --quiet ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda:${TAG})  
  IMAGE_SHA=$(aws ecr describe-images --repository-name pontus-comply-keycloak-lambda --image-ids imageTag=${TAG} | jq -r '.imageDetails[0].imageDigest')
  aws lambda update-function-code --function-name keycloak  --image-uri 558029316991.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-keycloak-lambda@${IMAGE_SHA}
fi
rm KEYCLOAK_PASSWORD_FILE KEYCLOAK_USER_FILE


