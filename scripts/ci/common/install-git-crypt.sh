#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -e
set -o pipefail

sudo apt-get --allow-releaseinfo-change update
sudo apt-get install -y --no-install-recommends git ssh git-crypt
