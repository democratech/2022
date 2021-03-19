#!bash

# This script will export the Ghost MySQL database from the prod environment
# into a single SQL file. This file is then imported automatically when provisioning
# the laprimaire.org role.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SSH_USER=${SSH_USER:-$USER}
SSH_HOSTNAME=${SSH_HOSTNAME:-'org.laprimaire.org'}
SSH_PRIV_KEY=${SSH_PRIV_KEY:-'./key/laprimaire.org'}

POSTGRESQL_DATABASE=${POSTGRESQL_DATABASE:-'discourse'}

ssh -i ${SSH_PRIV_KEY} \
    ${SSH_USER}@${SSH_HOSTNAME} \
    sudo docker exec -u postgres app pg_dump -C -d ${POSTGRESQL_DATABASE} \
    > ./provisioning/roles/laprimaire.forum/files/postgresql-initdb.d/01-discourse.sql
