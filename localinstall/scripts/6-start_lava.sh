#!/bin/bash

. ./config/main.cfg

set -e

cd kernelci/lava-docker

cd output/local
docker compose down
docker compose up -d

echo "Waiting for LAVA master to be up"
sleep 15
# loop until LAVA master is up, try 5 times
i=0
while [ $i -lt 5 ]; do
    if curl -s --fail http://localhost:10070/api/v0.2/system/ > /dev/null; then
        echo "LAVA master is up!"
        break
    else
        echo "LAVA master not ready yet, retrying..."
        sleep 5
    fi
done

echo "Waiting for LAVA worker to be up"
sleep 10
# loop until LAVA worker is up, try 5 times
i=0
while [ $i -lt 5 ]; do
    ANSWER=$(curl -s http://localhost:10070/api/v0.2/workers/)
    # must contain "hostname": "lava-slave" and "state": "Online"
    if echo "$ANSWER" | jq -e '.results[] | select(.hostname == "lava-slave-local" and .state == "Online")' >/dev/null; then
        echo "LAVA worker 'lava-slave-local' is online"
        break
    else
        echo "LAVA worker not ready yet, retrying..."
        i=$((i+1))
        sleep 5
    fi
done

