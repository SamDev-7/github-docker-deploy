#!/bin/bash

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
# - GITHUB_TOKEN  - Optional - A personal access token if the repo is private
# - GITHUB_USER   - Optional - The username associated with the token
# 2. (Optional) Create a writable volume mapped to the working directory.
# 3. Setup docker to run the following command per startup.
#   bash <(curl -s https://sh.samliu.dev/github_docker.sh)
#
# ==============================================================================

echo "Preparing to Deploy Repository ${GIT_REPO}..."

