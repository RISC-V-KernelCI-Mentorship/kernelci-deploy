#!/bin/bash

set -e

IMAGE_NAME="local/kernelci-deployer:latest"
BUILD_IMAGE=false

function print_help() {
  echo "Usage: $0 [--build]"
  echo
  echo "Options:"
  echo "  --build     Force rebuild of the Docker image"
  echo "  -h, --help  Show this help message"
  exit 0
}

for arg in "$@"; do
  case $arg in
    --build)
      BUILD_IMAGE=true
      ;;
    -h|--help)
      print_help
      ;;
    *)
      echo "Unknown option: $arg"
      print_help
      ;;
  esac
done

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

if [[ "$BUILD_IMAGE" = true || -z $(docker images -q $IMAGE_NAME) ]]; then
  echo "Building $IMAGE_NAME"
  docker build \
    --build-arg USER_ID=$USER_ID \
    --build-arg GROUP_ID=$GROUP_ID \
    -f Containerfile \
    -t $IMAGE_NAME \
    .
else
  echo "$IMAGE_NAME image already existing"
fi

echo "Running $IMAGE_NAME"
docker run --rm \
  --name kernelci-deployer \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)":"$(pwd)" \
  --workdir "$(pwd)" \
  --group-add $(stat -c '%g' /var/run/docker.sock) \
  --network host \
  $IMAGE_NAME

