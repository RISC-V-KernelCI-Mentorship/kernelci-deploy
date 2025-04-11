#! /bin/bash

set -e 

cd scripts

./1-rebuild_all.sh
./2-install_api.sh
./3-install_pipeline.sh
./4-start_cycle.sh
