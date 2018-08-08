#!/bin/bash

PREVIOUS_VERSION=$PROJECT_VERSION

# Fetch changes from branch name
MAJOR_CHANGES=$(grep -io '^release/' <<< "${TRAVIS_BRANCH}" | wc -l)
MINOR_CHANGES=$(grep -io '^feature/' <<< "${TRAVIS_BRANCH}" | wc -l)
PATCH_CHANGES=$(grep -io '^hotfix/' <<< "${TRAVIS_BRANCH}" | wc -l)

# Convert values to numbers (trims leading spaces)
MAJOR_CHANGES=$(expr $MAJOR_CHANGES + 0)
MINOR_CHANGES=$(expr $MINOR_CHANGES + 0)
PATCH_CHANGES=$(expr $PATCH_CHANGES + 0)

# Generate next version.
parts=( ${PREVIOUS_VERSION//./ } )
NEXT_MAJOR_VERSION=$(expr ${parts[0]} + ${MAJOR_CHANGES})

if [[ ${MAJOR_CHANGES} != "0" ]]; then
  NEXT_MINOR_VERSION="0"
else
  NEXT_MINOR_VERSION=$(expr ${parts[1]} + ${MINOR_CHANGES})
fi;

if [[ ${MAJOR_CHANGES} != "0" || ${MINOR_CHANGES} != "0" ]]; then
  NEXT_PATCH_VERSION="0"
elif [[ ${PATCH_CHANGES} == "0" ]]; then
  NEXT_PATCH_VERSION=$(expr ${parts[2]} + 1)
else
  NEXT_PATCH_VERSION=$(expr ${parts[2]} + ${PATCH_CHANGES})
fi;

NEXT_VERSION="${NEXT_MAJOR_VERSION}.${NEXT_MINOR_VERSION}.${NEXT_PATCH_VERSION}"

if [[ "${MAJOR_CHANGES}" == "0" && "${MINOR_CHANGES}" == "0" && "${PATCH_CHANGES}" == "0" ]]; then
  echo "[ERROR] No version changes was detected. Branch name should start with release/*, feature/* or hotfix/* prefix."
  exit 1
fi;

# Show version info
echo
echo "Version information: "
echo " - Previous version was ${PREVIOUS_VERSION}"
echo " - Next version will be ${NEXT_VERSION}"

export PREVIOUS_VERSION=$PREVIOUS_VERSION
export NEXT_VERSION=$NEXT_VERSION
export PROJECT_VERSION=$NEXT_VERSION
