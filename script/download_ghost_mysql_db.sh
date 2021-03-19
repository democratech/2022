#!bash

# This script will export the Ghost MySQL database from the prod environment
# into a single SQL file. This file is then imported automatically when provisioning
# the laprimaire.org role.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SSH_USER=${SSH_USER:-$USER}
SSH_HOSTNAME=${SSH_HOSTNAME:-'2022.laprimaire.org'}
SSH_PRIV_KEY=${SSH_PRIV_KEY:-'./key/laprimaire.org'}

MYSQL_USER=${MYSQL_USER:-'ghost-910'}
MYSQL_DATABASE=${MYSQL_DATABASE:-'ghost_prod'}

ssh -i ${SSH_PRIV_KEY} \
    ${SSH_USER}@${SSH_HOSTNAME} \
    mysqldump --no-tablespaces -p -u ${MYSQL_USER} ${MYSQL_DATABASE} \
    > ./provisioning/roles/laprimaire.blog/files/mysql-initdb.d/01-ghost_prod.sql
