#!/bin/bash

set -e

# Github
REPO_URL="https://github.com/${TRAVIS_REPO_SLUG}.git";

echo "Setting Gih user/password";
git config --global user.email "travis@travis-ci.com";
git config --global user.name "Travis-CI";
git config --global push.default upstream;
git remote add upstream ${REPO_URL} &> /dev/null

# DockerHub
if [ ! $HUB_ACCOUNT  ]; then
  echo "[E] You need to specify Docker Hub account with '-a' option."
  exit 1
fi

echo "Logging in into Docker Hub";
echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
