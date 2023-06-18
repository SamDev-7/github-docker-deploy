#!/bin/bash
set -e

# GitHub Docker Deploy
# 
# By Sam Liu (SamDev-7) 
# Source: https://github.com/SamDev-7/github-docker-deploy
# Copyright (c) 2023 - License: MIT
#
# ==============================================================================
# A script to deploy code from a GitHub repository to a Docker containe without  
# the need to create, update, and host a Docker container image.
#
# The script attempts to:
# - Clone the repository if it has not been cloned.
# - Otherwise, pull changes from the repository.
# - Build the code, if code changed, with the specified command.
# - Run the specified command to start the app.
#
# To avoid the need to clone the repository multiple times, it is advised to
# create a persistent volume for the code. The volume should be mapped to the
# same location as the working directory.
#
# Usage
# ==============================================================================
# 1. Set up environment variables:
# - RUN_COMMAND   - Required - The command to run the code
# - BUILD_COMMAND - Required - The command to build the code
# - GIT_REPO      - Required - The repo to deploy (e.g. https://github.com/someuser/somerepo.git)
# - GIT_BRANCH    - Required - The branch to deploy (e.g. master)
# 2. (Optional) Create a writable volume mapped to the working directory.
# 3. Setup docker to run the following command per startup.
#   bash <(curl -s https://sh.samliu.dev/github_docker.sh)
#
# ==============================================================================

echo "Preparing to Deploy Repository ${GIT_REPO}..."

needs_build=false
if [ -d ./.git ]; then
  echo "Repository already cloned. Checking for changes..."
  git fetch
  changed_files=$(git diff origin/${GIT_BRANCH} --name-only )
  if [ -n "${changed_files}" ]; then
    echo "Changes detected.."
    git pull
    needs_build=true
  else
    echo "No changes detected."
  fi
else
  echo "Repository is not cloned. Cloning..."
  git clone ${GIT_REPO} -b ${GIT_BRANCH} --depth 1 .
  needs_build=true
fi

if [ "${needs_build}" = true ]; then
  echo "The code needs to be built. Building..."
  echo "Executing \$ ${BUILD_COMMAND}"
  /bin/sh -c \"${BUILD_COMMAND}\"
fi

echo "Running..."
echo "Executing \$ ${RUN_COMMAND}"
/bin/sh -c \"${RUN_COMMAND}\"

 
