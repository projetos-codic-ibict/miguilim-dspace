#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables
start_tomcat
