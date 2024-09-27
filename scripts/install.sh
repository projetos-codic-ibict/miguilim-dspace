#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath "$0"))

. "$SCRIPT_DIR/_shared.sh"

check_dir() {
  local target_dir="$1"

  echo_info "Checando diretório: $target_dir"

  if [ -e "$target_dir" -a ! -d "$target_dir" ]; then
    echo_error "Caminho $target_dir existe e não é um diretório"
    return 1
  elif [ -d "$target_dir" ]; then
    if [ ! -z "$(ls -A "$target_dir")" ]; then
      echo_warn "$target_dir não está vazio. Pulando..."
    fi
  fi

  return 0
}

extract_zip() {
  local zip_file="$1"
  local target_dir="$2"
  local temp_dir="$(mktemp -d)"

  check_dir "$target_dir" || return 1
  echo_info "Extraindo arquivo zip $zip_file"
  unzip "$zip_file" -d "$temp_dir"
  mv "$temp_dir"/* "$target_dir"
  rmdir "$temp_dir"

  return 0
}

setup_requirements() {
  local setup_requirements
  read -p "Preparar requisitos? [Y/n] " setup_requirements

  case "$setup_requirements" in
    [Nn]* ) return; break;;
  esac

  check_dir "$BASE_DIR" || return 1

  echo_info "Preparando requisitos"

  mkdir -p "$BASE_DIR"

  echo_info "Conferindo se arquivos zip existem"
  [ ! -e "$MAVEN_ZIP" ] && echo_info "Arquivo zip do maven não existe: $MAVEN_ZIP" && return 1
  [ ! -e "$TOMCAT_ZIP" ] && echo_info "Arquivo zip do Tomcat não existe $TOMCAT_ZIP" && return 1

  echo_info "Instalando pacotes apt"
  sudo apt install openjdk-8-jdk openjdk-8-jre git ant postgresql unzip

  echo_info "Você deve mudar a versão padrão do java para a versão 8"
  sudo update-alternatives --config java

  echo_info "Extraindo arquivos zip"
  extract_zip "$MAVEN_ZIP" "$MAVEN_DIR" || return 1
  extract_zip "$TOMCAT_ZIP" "$TOMCAT_DIR" || return 1

  echo_info "Mudando scripts do Tomcat para executáveis"
  chmod u+x "$TOMCAT_DIR/bin"/*.sh

  return 0
}

download_maven() {
  curl -O https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.zip
  echo "$(pwd)/apache-maven-3.8.8-bin.zip"
}

download_tomcat() {
  curl -O https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.zip
  echo "$(pwd)/apache-tomcat-8.5.100.zip"
}

clone_repository() {
  echo_info "Clonando repositório do miguilim"

  if [ -d "$MIGUILIM_SOURCE_DIR" ]; then
    if [ ! -z "$(ls -A "$MIGUILIM_SOURCE_DIR")" ]; then
      echo_info "$MIGUILIM_SOURCE_DIR não está vazio. Pulando git clone..."
      return
    fi
  fi

  git clone "$MIGUILIM_GIT_REPOSITORY" "$MIGUILIM_SOURCE_DIR"

  return 0
}

edit_config_file() {
  cp "$MIGUILIM_SOURCE_DIR/dspace/config/docker.cfg" "$MIGUILIM_SOURCE_DIR/dspace/config/local.cfg"

  echo_info "Editando arquivo de configuração"
  echo_info "Você precisa editar o arquivo de configuração manualmente. Lembre-se que este arquivos não expande variáveis de ambiente nem ~"
  echo_info "Edições necessárias:"
  echo "dspace.dir = $MIGUILIM_INSTALLATION_DIR"
  [ "$MIGUILIM_DB_NAME" != "dspace" ] && echo "db.url = jdbc:postgresql://localhost:5432/$MIGUILIM_DB_NAME"
  [ "$MIGUILIM_DB_USERNAME" != "dspace" ] && echo "db.username = $MIGUILIM_DB_USERNAME"
  [ "$MIGUILIM_DB_PASSWORD" != "dspace" ] && echo "db.password = $MIGUILIM_DB_PASSWORD"
  local answer
  printf "%s" "Press enter to continue" && read answer
  "$EDITOR" "$MIGUILIM_SOURCE_DIR/dspace/config/local.cfg"

  return 0
}

install_miguilim() {
  echo_info "Instalando Miguilim"
  mkdir -p "$MIGUILIM_INSTALLATION_DIR"
  cd "$MIGUILIM_SOURCE_DIR/dspace/target/dspace-installer"
  ant fresh_install

  return 0
}

start() {
  local answer
  read -p "Start? [Y/n] " answer

  case "$answer" in
    [Nn]* ) break;;
    * ) start_tomcat; break;;
  esac

  return 0
}

init_variables &&
setup_requirements &&
clone_repository &&
setup_postgres &&
edit_config_file &&
install_maven_dependencies &&
install_miguilim &&
add_webapps_to_tomcat &&
create_miguilim_administrator &&
start
