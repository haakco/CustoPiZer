#!/usr/bin/env bash
export BUILD_IMAGE_NAME="${BUILD_IMAGE_NAME}"
export BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}"
export BUILD_IMAGE_REPOSITORY="${BUILD_IMAGE_REPOSITORY}"
export DOCKER_FILE="${DOCKER_FILE:-"src/Dockerfile"}"
export EXTRA_FLAG="${EXTRA_FLAG}"

export DOCKER_BUILDKIT=1

echo "Tagged as : ${IMAGE_NAME}"
echo ""
echo ""

CACHE_FROM=""

export CACHE_DIR="/tmp/docker-buildx-cache/${BUILD_IMAGE_NAME}"

if [ -f "${CACHE_DIR}/index.json" ]; then
  export CACHE_FROM="${CACHE_FROM} --cache-from=type=local,src=${CACHE_DIR}"
fi
export CACHE_FROM="${CACHE_FROM} --cache-to=type=local,dest=${CACHE_DIR}"

mkdir -p "${CACHE_DIR}"

if [[ "$CACHE_FROM" == *"type=local"* ]]; then
  mkdir -p "${CACHE_DIR}"
fi

#CACHE_FROM="${CACHE_FROM} --cache-from=type=registry,ref=${BUILD_IMAGE_REPOSITORY}/${BUILD_IMAGE_NAME}:buildcache"
#export CACHE_FROM="${CACHE_FROM} --cache-to=type=registry,ref=${BUILD_IMAGE_REPOSITORY}/${BUILD_IMAGE_NAME}:buildcache,mode=max"

BUILD_TYPE_FLAG=" --load "
#BUILD_TYPE_FLAG=" --push "
export BUILD_TYPE_FLAG

if [[ "${BUILD_TYPE_FLAG}" == *"load"* ]]; then
  if [[ "$(dpkg-architecture -q DEB_BUILD_GNU_CPU)" == "x86_64" ]]; then
    PLATFORM=" --platform linux/amd64 "
  else
    PLATFORM=" --platform linux/arm64/v8 "
  fi
else
  PLATFORM=" --platform  linux/arm64/v8,linux/amd64 "
#  PLATFORM=" --platform  linux/arm64/v8 "
#  PLATFORM=" --platform linux/amd64 "
fi

CMD='docker buildx build --pull  '"${PLATFORM}"' '"${BUILD_TYPE_FLAG}"' '"${CACHE_FROM}"' --rm --file '"${DOCKER_FILE}"' -t '"${BUILD_IMAGE_REPOSITORY}/${BUILD_IMAGE_NAME}:${BUILD_IMAGE_TAG}"' '"${EXTRA_FLAG}"' .'

echo "Build command: ${CMD}"
echo ""
${CMD}

#DOCKER_PULL_CMD='docker pull '"${BUILD_IMAGE_NAME}"':'"${BUILD_IMAGE_TAG}"''
#echo "Command: ${DOCKER_PULL_CMD}"
#${DOCKER_PULL_CMD}
