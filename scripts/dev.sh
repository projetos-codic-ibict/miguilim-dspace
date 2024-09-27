#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables
. "$SCRIPT_DIR/build.sh"
. "$SCRIPT_DIR/restart.sh"
