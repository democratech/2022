#!/bin/bash
set -o nounset -o pipefail -o errexit

# Load all variables from .env and export them all for Ansible to read
if [ -f $(dirname "$0")/../.env ]; then
    set -o allexport
    source $(dirname "$0")/../.env
    set +o allexport
fi

# Run Ansible
exec ansible-playbook "$@"
