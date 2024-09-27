#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

remove_log_files() {
  echo_info "Removendo arquivos de log na instalação do Miguilim"
  rm -f $MIGUILIM_INSTALLATION_DIR/log/*
}

update_installation() {
  echo_info "Atualizando instalação"
  cd "$MIGUILIM_SOURCE_DIR/dspace/target/dspace-installer"
  ant -Dconfig=$MIGUILIM_INSTALLATION_DIR/config/dspace.cfg update
}

init_variables
stop_tomcat
remove_target
install_maven_dependencies
remove_log_files
update_installation
add_webapps_to_tomcat
