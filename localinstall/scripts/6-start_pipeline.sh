#!/bin/bash

# is docker-compose exists? if not use docker compose
if [ -z "$(which docker-compose)" ]; then
    echo "docker-compose is not installed, using docker compose"
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

. ./config/main.cfg

set -e

cd kernelci/kernelci-pipeline

${DOCKER_COMPOSE} down
${DOCKER_COMPOSE} up -d