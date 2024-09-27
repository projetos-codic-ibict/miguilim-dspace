#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables
drop_miguilim_user_and_databases
setup_postgres
create_miguilim_administrator
