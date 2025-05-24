#!/bin/bash

set -e

ACTION=$1

function print_help() {
  echo "Usage: $0 (deploy|start|stop)"
  echo
  echo "  deploy  Configure and start deployment"
  echo "  start   Start deployment"
  echo "  stop    Stop deployment"
  exit 1
}

function check_deploy() {
  if [ ! -f kernelci/.done ]; then
    echo "Error: Deployment not completed. Please run 'deploy' first."
    exit 1
  fi
}

if [[ -z "$ACTION" ]]; then
  echo "Error: Missing required action (deploy, start or stop)"
  print_help
fi

case "$ACTION" in
  deploy)
    # Check if kernelci directory exists
    if [ -f kernelci/.done ]; then
      echo "Stopping previous deployment..."
      $0 stop
    fi
    sudo rm -rf kernelci
    echo "Starting deployment sequence, this may take a while..."
    ./scripts/1-rebuild_all.sh
    ./scripts/2-prepare_api.sh
    ./scripts/3-start_api.sh
    ./scripts/4-set_api_admin.sh
    ./scripts/5-prepare_lava.sh
    ./scripts/6-start_lava.sh
    ./scripts/7-prepare_pipeline.sh
    ./scripts/8-start_pipeline.sh
    echo "You can view now logs of containers using docker logs -f <container_id> or docker-compose logs -f in each directory"
    echo "Also you can do docker ps to see running containers, and in case of ongoing builds, you can view their logs too by docker logs -f <container_id>"
    echo "API viewer available at http://localhost:8001/viewer"
    echo "API endpoints available at http://localhost:8001"
    echo "Storage is available at http://localhost:8002/"
    echo "Pipeline callback available at http://localhost:8100"
    echo "LAVA available at http://localhost:10070"
    touch kernelci/.done
    ;;
  start)
    check_deploy
    echo "Starting deployment"
    ./scripts/3-start_api.sh
    ./scripts/6-start_lava.sh
    ./scripts/8-start_pipeline.sh
    ;;
  stop)
    check_deploy
    echo "Stopping deployment"
    cd kernelci/kernelci-api
    docker compose down
    cd ../kernelci-pipeline
    docker compose down
    cd ../lava-docker/output/local
    docker compose down
    ;;
  *)
    echo "Error: Invalid action '$ACTION'"
    print_help
    ;;
esac
