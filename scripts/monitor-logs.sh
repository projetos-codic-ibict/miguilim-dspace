#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

init_variables

cd "$MIGUILIM_INSTALLATION_DIR/log"

if [ -z "$1" ]; then
  TARGET="dspace"
else
  TARGET="$1"
fi

case "$TARGET" in
  checker ) LOGFILE_NAME="$TARGET.log.$(date +'%Y-%m-%d')"; break;;
  cocoon ) LOGFILE_NAME="$TARGET.log.$(date +'%Y-%m-%d')"; break;;
  dspace ) LOGFILE_NAME="$TARGET.log.$(date +'%Y-%m-%d')"; break;;
  solr ) LOGFILE_NAME="$TARGET.log"; break;;
  * ) echo_error "argumento inválido!"; exit 1;;
esac

if [ -f "$LOGFILE_NAME" ]; then
  tail -f "$LOGFILE_NAME" -n 1
else
  echo_error "Arquivo de log $LOGFILE_NAME não existe!"
fi
