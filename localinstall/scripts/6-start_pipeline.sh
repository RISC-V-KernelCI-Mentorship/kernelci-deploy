#!/bin/bash

. ./config/main.cfg

set -e

cd kernelci/kernelci-pipeline

docker compose down
docker compose up -d
