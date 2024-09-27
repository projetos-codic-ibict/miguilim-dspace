#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables
echo_info "Reiniciando o tomcat"
stop_tomcat
start_tomcat
