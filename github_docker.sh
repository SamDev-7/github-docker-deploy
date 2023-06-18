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
# Create a persistent volume for the code. The volume should be mapped to the
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
  echo "Repository already cloned. Pulling changes..."
  git fetch
  git pull --force
else
  echo "Repository is not cloned. Cloning..."
  git clone ${GIT_REPO} -b ${GIT_BRANCH} --depth 1 .
fi

echo "Building..."
echo "Executing \$ ${BUILD_COMMAND}"
/bin/sh -c "${BUILD_COMMAND}"

echo "Running..."
echo "Executing \$ ${RUN_COMMAND}"
/bin/sh -c "${RUN_COMMAND}"
