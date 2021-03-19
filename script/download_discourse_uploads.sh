#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SSH_USER=${SSH_USER:-$USER}
SSH_HOSTNAME=${SSH_HOSTNAME:-'org.laprimaire.org'}
SSH_PRIV_KEY=${SSH_PRIV_KEY:-'./key/laprimaire.org'}

scp -r \
    -i ${SSH_PRIV_KEY} \
    ${SSH_USER}@${SSH_HOSTNAME}:/var/discourse/shared/standalone/uploads/default/ \
    ./provisioning/roles/laprimaire.forum/files/uploads/
