#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables

echo_info "Re-indexando"

if [ "$1" = "" ]; then
  "$MIGUILIM_INSTALLATION_DIR/bin/dspace" index-discovery -b
else
  "$MIGUILIM_INSTALLATION_DIR/bin/dspace" index-discovery -i "$1"
fi
