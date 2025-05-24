#!/bin/bash

# Export vars for envsubst
set -a
. ./config/main.cfg
set +a

set -e

# Set LAVA secrets
envsubst < config/lava-boards-template.yaml > config/out/lava-boards.yaml

# Copy config files
cp config/out/lava-boards.yaml kernelci/lava-docker/boards.yaml

cd kernelci/lava-docker

# generate docker-compose file
./lavalab-gen.sh

# Build the Docker images
cd output/local
docker compose build
