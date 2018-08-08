#!/bin/bash
# This script simplifies releasing a new Docker image of your release.
# It will run following steps:
#   1. Create git tag with version number specified in mix.exs
#   2. Tag Docker container that is created by build.sh script to a Docker Hub repo.
#   3. Upload changes to Docker Hub.
#
# Usage:
# ./bin/release.sh -a DOCKER_HUB_ACCOUNT_NAME [-v RELEASE_VERSION -l -s -f]
#   '-l' - create additional tag 'latest'.
#   '-s' - create additional tag 'stable'.
#   '-f' - force tag creating when git working tree is not empty.
set -e

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

# Default settings

if git diff-index --quiet HEAD --; then
  PASS_GIT=1
  # no changes
else
  PASS_GIT=0
fi

CONTAINER_VERSION="${PROJECT_VERSION}-${TRAVIS_JOB_NUMBER}"
IS_STABLE=0
RELEASE_VERSION=$NEXT_VERSION
HUB_ACCOUNT=$DOCKER_HUB_ACCOUNT
IS_LATEST=1
GIT_TAG="${RELEASE_VERSION}-${PROJECT_NAME}"

# Create git tag that matches release version
if [ `git tag --list ${GIT_TAG}` ]; then
  echo "[W] Git tag '${GIT_TAG}' already exists. It won't be created during release."
else
  if [ ! $PASS_GIT ]; then
    echo "[E] Working tree contains uncommitted changes. This may cause wrong relation between image tag and git tag."
    echo "    You can skip this check with '-f' option."
    exit 1
  else
    echo "[I] Creating git tag '${GIT_TAG}'.."
    git tag -a ${GIT_TAG} -m "${CHANGELOG}"$'\n'$'\n'"Container URL: https://hub.docker.com/r/${DOCKER_HUB_ACCOUNT}/${PROJECT_NAME}/tags/${CONTAINER_VERSION}/"
  fi
fi

#echo "[I] Tagging image '${PROJECT_NAME}:${CONTAINER_VERSION}' into a Docker Hub repository '${HUB_ACCOUNT}/${PROJECT_NAME}:${CONTAINER_VERSION}'.."
#docker tag "${PROJECT_NAME}:${CONTAINER_VERSION}" "${HUB_ACCOUNT}/${PROJECT_NAME}:${CONTAINER_VERSION}"
#
#if [ $IS_LATEST == 1 ]; then
#  echo "[I] Assigning additional tag '${HUB_ACCOUNT}/${PROJECT_NAME}:latest'.."
#  docker tag "${PROJECT_NAME}:${CONTAINER_VERSION}" "${HUB_ACCOUNT}/${PROJECT_NAME}:latest"
#fi
#
#if [ $IS_STABLE == 1 ]; then
#  echo "[I] Assigning additional tag '${HUB_ACCOUNT}/${PROJECT_NAME}:stable'.."
#  docker tag "${PROJECT_NAME}:${CONTAINER_VERSION}" "${HUB_ACCOUNT}/${PROJECT_NAME}:stable"
#fi
#
#echo "[I] Pushing changes to Docker Hub.."
#docker push "${HUB_ACCOUNT}/${PROJECT_NAME}"
