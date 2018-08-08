#!/bin/bash
# This setup works with Travis-CI.
# You need to specify $DOCKER_HUB_ACCOUNT, $DOCKER_USERNAME and $DOCKER_PASSWORD before using this script.
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_URL="https://github.com/${TRAVIS_REPO_SLUG}.git";

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
  git add "apps/attestation_api/mix.exs";
  git add "apps/mobile_api/mix.exs";
  git commit -m "Increment version [ci skip]";

  echo "Current branch: ${TRAVIS_BRANCH}"
  echo "Trunk branch: ${TRUNK_BRANCH}"

  if [[ "${TRAVIS_BRANCH}" == "${TRUNK_BRANCH}" ]]; then

    # Save some useful information
    REPO=`git config remote.origin.url`
    SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
    SHA=`git rev-parse --verify HEAD`

    # Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
    ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
    ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
    ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
    ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
    openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in "${TRAVIS_BUILD_DIR}/github_deploy_key.enc" -out github_deploy_key -d
    chmod 600 github_deploy_key
    eval `ssh-agent -s`
    ssh-add github_deploy_key

    echo "Pushing changes back to origin repo.";
    git push $SSH_REPO HEAD:$TRUNK_BRANCH;
    echo "Done.";
  else
    echo "[I] This build is not in a trunk or maintenance branch, new version will not be created"
  fi;
else
  echo "[I] This build is a pull request, new version will not be created"
fi;
