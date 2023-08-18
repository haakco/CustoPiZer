#!/usr/bin/env bash
export DOCKER_FILE="./src/Dockerfile"

SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR

## Build args
export BASE_IMAGE_NAME="debian"
export BASE_IMAGE_TAG="bookworm-backports"

export BUILD_IMAGE_REPOSITORY="${BUILD_IMAGE_REPOSITORY:-ghcr.io/octoprint}"
export BUILD_IMAGE_NAME="custopizer"
export BUILD_IMAGE_TAG="latest"

EXTRA_FLAG="${EXTRA_FLAG} --build-arg BASE_IMAGE_NAME=${BASE_IMAGE_NAME}"
EXTRA_FLAG="${EXTRA_FLAG} --build-arg BASE_IMAGE_TAG=${BASE_IMAGE_TAG}"
export EXTRA_FLAG

"${SCRIPT_DIR}/sharedBaseBuild.sh"
