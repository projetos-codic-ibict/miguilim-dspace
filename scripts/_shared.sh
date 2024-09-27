#!/bin/bash

echo_info() {
  echo "Info:" $@
}

echo_error() {
  echo "Erro:" $@ >&2
}

echo_warn() {
  echo "Aviso:" $@
}

init_variables() {
  # ./install.sh {{{
  [ -z "$MAVEN_ZIP" ] && MAVEN_ZIP="$HOME/Downloads/apache-maven-3.8.8-bin.zip"
  [ -z "$TOMCAT_ZIP" ] && TOMCAT_ZIP="$HOME/Downloads/apache-tomcat-8.5.100.zip"
  [ -z "$MIGUILIM_GIT_REPOSITORY" ] && MIGUILIM_GIT_REPOSITORY="https://github.com/projetos-codic-ibict/miguilim-dspace"

  [ -z "$EDITOR" ] && EDITOR="nvim"

  [ -z "$MIGUILIM_ADMIN_EMAIL" ] && MIGUILIM_ADMIN_EMAIL="admin@admin.com"
  [ -z "$MIGUILIM_ADMIN_FIRST_NAME" ] && MIGUILIM_ADMIN_FIRST_NAME="admin"
  [ -z "$MIGUILIM_ADMIN_LAST_NAME" ] && MIGUILIM_ADMIN_LAST_NAME="admin"
  [ -z "$MIGUILIM_ADMIN_LANGUAGE" ] && MIGUILIM_ADMIN_LANGUAGE="pt_BR"
  [ -z "$MIGUILIM_ADMIN_PASSWORD" ] && MIGUILIM_ADMIN_PASSWORD="admin"
  # }}}

  # ./uninstall.sh {{{
  [ -z "$REMOVE_MIGUILIM_SOURCE_DIR" ] && REMOVE_MIGUILIM_SOURCE_DIR=0
  # }}}

  [ -z "$BASE_DIR" ] && BASE_DIR="$HOME/miguilim"

  [ -z "$MAVEN_DIR" ] && MAVEN_DIR="$BASE_DIR/maven"
  [ -z "$TOMCAT_DIR" ] && TOMCAT_DIR="$BASE_DIR/tomcat"

  [ -z "$MIGUILIM_SOURCE_DIR" ] && MIGUILIM_SOURCE_DIR="$HOME/miguilim-source"
  [ -z "$MIGUILIM_INSTALLATION_DIR" ] && MIGUILIM_INSTALLATION_DIR="$BASE_DIR/miguilim_installation"
  [ -z "$MIGUILIM_DB_NAME" ] && MIGUILIM_DB_NAME="dspace"
  [ -z "$MIGUILIM_DB_USERNAME" ] && MIGUILIM_DB_USERNAME="dspace"
  [ -z "$MIGUILIM_DB_PASSWORD" ] && MIGUILIM_DB_PASSWORD="dspace"

  [ -z "$MIGUILIM_DUMP_FILE" ] && MIGUILIM_DUMP_FILE="$HOME/dev/miguilim_prod_dumps/dspace_dump_prod_2024_09_11.sql"

  return 0
}

add_webapps_to_tomcat() {
  echo_info "Adicionando webapps ao Tomcat"

  cp -r "$MIGUILIM_INSTALLATION_DIR/webapps/jspui" "$TOMCAT_DIR/webapps/"
  cp -r "$MIGUILIM_INSTALLATION_DIR/webapps/rest" "$TOMCAT_DIR/webapps/"
  cp -r "$MIGUILIM_INSTALLATION_DIR/webapps/solr" "$TOMCAT_DIR/webapps/"
  rm -rf "$TOMCAT_DIR/webapps/ROOT"
  cp -r "$MIGUILIM_INSTALLATION_DIR/webapps/jspui" "$TOMCAT_DIR/webapps/ROOT"

  return 0
}

remove_target() {
  cd "$MIGUILIM_SOURCE_DIR"
  echo_info "Removendo target"
  git clean -X -f **/target
}

install_maven_dependencies() {
  cd "$MIGUILIM_SOURCE_DIR"
  echo_info "Instalando dependências maven"
  echo_info "Você precisa manualmente editar o arquivo de configuração do maven para para preveni-lo de bloquear http, veja: https://stackoverflow.com/a/67295342"

  "$MAVEN_DIR/bin/mvn" clean package -P !dspace-sword,!dspace-swordv2,!dspace-oai

  return 0
}

stop_tomcat() {
  echo_info "Parando execução do tomcat, se já estiver rodando"
  "$TOMCAT_DIR/bin/shutdown.sh" 2> /dev/null
}

start_tomcat() {
  echo_info "Iniciando execução do tomcat"
  "$TOMCAT_DIR/bin/catalina.sh" run
}

drop_miguilim_user_and_databases() {
  echo_info "Fazendo drop do usuário do Miguilim e seus bancos de dados"
  sudo -iu postgres psql -c "DROP OWNED BY $MIGUILIM_DB_USERNAME;"
  sudo -iu postgres psql -c "DROP DATABASE $MIGUILIM_DB_NAME;"
  sudo -iu postgres psql -c "DROP USER $MIGUILIM_DB_USERNAME;"
}

setup_postgres() {
  local change_postgres_password

  echo_info "Preparando postgres"

  echo_info "Você precisa definir uma senha do postgres caso não fez ainda, senão os próximos comandos vão falhar depois de pedir a senha"
  read -p "Mudar senha do postgres? [y/N] " change_postgres_password
  case "$change_postgres_password" in
    [Yy]* ) sudo passwd postgres; break;;
  esac

  echo_info "Criando usuário postgres: $MIGUILIM_DB_USERNAME"
  sudo -iu postgres psql -c "create role $MIGUILIM_DB_USERNAME with login password '$MIGUILIM_DB_PASSWORD';"

  echo_info "Criando banco de dados $MIGUILIM_DB_NAME para o usuário $MIGUILIM_DB_USERNAME"
  sudo -iu postgres createdb --owner="$MIGUILIM_DB_USERNAME" --encoding=UNICODE "$MIGUILIM_DB_NAME"

  echo_info "Criando extensão pgcrypto no banco $MIGUILIM_DB_USERNAME"
  sudo -iu postgres psql "$MIGUILIM_DB_NAME" "$MIGUILIM_DB_USERNAME" -c "CREATE EXTENSION pgcrypto;"

  echo_info "Importando o dump do banco de dados"
  # Importar o dump dessa forma evita o problema de "peer authentication" sem
  # ter que editar o arquivo pg_hba.conf. https://stackoverflow.com/a/66664893
  sudo -iu postgres psql "postgresql://$MIGUILIM_DB_USERNAME:$MIGUILIM_DB_PASSWORD@localhost:5432/$MIGUILIM_DB_NAME" < "$MIGUILIM_DUMP_FILE"

  return 0
}

create_miguilim_administrator() {
  echo_info "Criando administrador do Miguilim"
  "$MIGUILIM_INSTALLATION_DIR/bin/dspace" create-administrator \
    --email "$MIGUILIM_ADMIN_EMAIL" \
    --first "$MIGUILIM_ADMIN_FIRST_NAME" \
    --last "$MIGUILIM_ADMIN_LAST_NAME" \
    --language "$MIGUILIM_ADMIN_LANGUAGE" \
    --password "$MIGUILIM_ADMIN_PASSWORD"

  return 0
}
