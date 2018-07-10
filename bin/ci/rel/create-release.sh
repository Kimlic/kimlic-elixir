#!/bin/bash

export UMBRELLA_PROJECT_DIR=${TRAVIS_BUILD_DIR:=$PWD}

APPS_LIST=( mobile_api attestation_api )

for APP_DIR in "${APPS_LIST[@]}"
do
    export PROJECT_DIR="${UMBRELLA_PROJECT_DIR}/apps/${APP_DIR}"
    export PROJECT_NAME=$(sed -n 's/.*app: :\([^, ]*\).*/\1/pg' "${PROJECT_DIR}/mix.exs")

    # Fetch application version
    source ./bin/ci/release/fetch-source-version.sh

    # Check for versioning error
    ./bin/ci/release/check-version-error.sh

    # Increment version in mix.exs
    ./bin/ci/release/put-source-version.sh || travis_terminate 1

    # Run all tests except pending ones
    #./bin/mix_tests.sh || travis_terminate 1

    # Build Docker container
    ./bin/ci/rel/build-container.sh || travis_terminate 1

    # Run Docker container and check that Docker container started
    sudo ./bin/ci/rel/start-container.sh || travis_terminate 1

    # Submit Docker container to Docker Hub and create GitHub Release by pushing tag with changelog
    ./bin/ci/rel/push-changes.sh || travis_terminate 1
done