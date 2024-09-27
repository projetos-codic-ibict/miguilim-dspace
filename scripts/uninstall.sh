#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

remove_directories() {
  local dir_var_names="BASE_DIR SOLR_DIR MAVEN_DIR TOMCAT_DIR MIGUILIM_INSTALLATION_DIR"

  if [ "$REMOVE_MIGUILIM_SOURCE_DIR" != 0 ]; then
    dir_var_names="$dir_var_names MIGUILIM_SOURCE_DIR"
  fi

  echo_info "Removendo diretórios"

  for dir_var_name in $dir_var_names; do
    eval local dir="\$$dir_var_name"

    if [ -d "$dir" ]; then
      echo_info "Removendo $dir"
      rm -rf "$dir"
    fi
  done
}

init_variables
stop_tomcat
drop_miguilim_user_and_databases
remove_directories
remove_target
