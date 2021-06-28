#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

cd $DIR/docker
docker build --rm . -t pontusvisiongdpr/pontus-comply-keycloak
docker push pontusvisiongdpr/pontus-comply-keycloak


