#!/bin/bash

##############################################
############### Variáveis ####################
##############################################

# SOURCE_CODE

## Compartilhar o .m2
## Compartilhar o /assetstore
## Compartilhar o /log

DSPACE_DIR=/dspace
SOURCE_FOLDER=dspace-source
SOURCE_DIR=/root/sources/${SOURCE_FOLDER}${EXTRA_FOLDER_TO_ACCESS_POM}
TOMCAT_HOME=/opt/apache-tomcat-8.5.51

function compila_dspace() {

  cd ${SOURCE_DIR}
  cat dspace/config/${CONFIG_FILE} >dspace/config/local.cfg
  echo "Iniciando a compilação do DSpace"
  mvn clean package -P !dspace-sword,!dspace-swordv2,!dspace-oai

}
function instala_dspace_ou_atualiza_dspace() {

  echo "Instalando o DSpace"
  cd ${SOURCE_DIR}/dspace/target/dspace-installer/

  if [[ ! -f "${DSPACE_DIR}/config/dspace.cfg" ]]; then

    echo "O arquivo DSpace.cfg não existe, tentando instalar o DSpace"
    if ant fresh_install; then
      echo "DSpace instalado"
    else
      echo "Ocorreu um erro ao tentar instalar o DSpace, recorrendo para a atualização"
      ant update
    fi
  else
    ant update
    echo "DSpace atualizado"
  fi
}

function declara_deploy_webapps() {

  echo "Efetuando link simbólico de aplicações"
  rm -rf /opt/apache-tomcat-8.5.51/webapps/ROOT
  ln -s /dspace/webapps/solr /opt/apache-tomcat-8.5.51/webapps/
  ln -s /dspace/webapps/rest /opt/apache-tomcat-8.5.51/webapps/
  ln -s /dspace/webapps/jspui /opt/apache-tomcat-8.5.51/webapps/ROOT
  if [ "${DEV_MODE}" = true ]; then
    ln -s /dspace/webapps/jspui /opt/apache-tomcat-8.5.51/webapps/"${CONTEXT_NAME}"
  fi
}

function remove_arquivos_instalacao() {

  cd ${SOURCE_DIR}
  echo "Executando clean do Maven"
  mvn clean

  echo "Removendo arquivos temporarios da pasta de instalação do DSpace"
  rm -rf ${DSPACE_DIR}/*bak*
}

function cria_arquivo_indicador_conclusao_build() {
  touch /opt/docker-build-complete
}

function instala_maven() {

  cd /opt/

  if [[ ! -f "/opt/docker-build-complete" ]]; then
    echo "Baixando Maven"
    wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip


    echo "Descompactando Maven"
    unzip apache-maven-3.6.3-bin.zip

    echo "Removendo zip do Maven"
    rm apache-maven-3.6.3-bin.zip

    echo "Acrescentando permissão de execução no binario do Maven"
    chmod 775 /opt/apache-maven-3.6.3/bin/mvn
  fi

  echo "Efetuando link simbolico do Maven"
  update-alternatives --install /usr/bin/mvn mvn /opt/apache-maven-3.6.3/bin/mvn 77
}

function instala_ant() {

  cd /opt/

  if [[ ! -f "/opt/docker-build-complete" ]]; then
    echo "Baixando ant"
    wget  https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.14-bin.zip

    echo "Descompactando Ant"
    unzip apache-ant-1.9.14-bin.zip

    echo "Removendo zip do Ant"
    rm apache-ant-1.9.14-bin.zip
  fi
  echo "Acrescentando permissão de execução no binario do Ant"
  chmod 775 /opt/apache-ant-1.9.14/bin/ant

  echo "Efetuando link simbolico do Ant"
  update-alternatives --install /usr/bin/ant ant /opt/apache-ant-1.9.14/bin/ant 78
}

function prepara_tomcat() {

  if [[ ! -f "/opt/docker-build-complete" ]]; then
      echo "Efetuando download do tomcat"
      wget  https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.51/bin/apache-tomcat-8.5.51.zip -P /opt/

      echo "Descompactando o Tomcat 8"
      unzip /opt/apache-tomcat-8.5.51.zip -d /opt/

      echo "Removendo arquivo compactado do tomcat"
      rm -rf /opt/apache-tomcat-8.5.51.zip
  fi
  echo "Aplicando permissões de execução no diretório de binários"
  chmod 775 /opt/apache-tomcat-8.5.51/bin/*
}

function habilita_solr_para_acesso_remoto() {
  sed -i 's/<param-name>LocalHostRestrictionFilter.localhost<\/param-name><param-value>true<\/param-value>/<param-name>LocalHostRestrictionFilter.localhost<\/param-name><param-value>false<\/param-value>/g' /opt/apache-tomcat-8.5.51/webapps/solr/WEB-INF/web.xml
}

function habilitar_acesso_ao_solr_somente_ips_internos() {
  arquivo_server_xml="/opt/apache-tomcat-8.5.51/conf/server.xml"
  arquivo_server_xml_default="$arquivo_server_xml.default"
  
  codigo_xml="<Context path=\"/solr\" reloadable=\"true\">\n        <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"127\\\.0\\\.0\\\.1|200\\\.130\\\.0\\\.12|172\\\.16\\\.16\\\.112\"/>\n        <Parameter name=\"LocalHostRestrictionFilter.localhost\" value=\"false\" override=\"false\" />\n</Context>"
  
  if [ ! -f "$arquivo_server_xml" ]; then
    echo "Erro: O arquivo $arquivo_server_xml não existe."
    return 1
  fi
  if [ ! -f "$arquivo_server_xml_default" ]; then
    cp "$arquivo_server_xml" "$arquivo_server_xml_default"
    echo "Criando backup $arquivo_server_xml_default"
  else
    # Remover o arquivo server.xml
    rm "$arquivo_server_xml"
    # Copia server.xml.default para server.xml
    cp "$arquivo_server_xml_default" "$arquivo_server_xml"
  fi
  # Localiza a tag </Host>
  linha_host=$(grep -n "</Host>" "$arquivo_server_xml" | head -n 1 | cut -d ':' -f 1)
  # Insere o código XML antes da tag </Host>
  sed -i "${linha_host}i ${codigo_xml}" "$arquivo_server_xml"
  echo "O código XML foi adicionado ao arquivo $arquivo_server_xml com sucesso."
}

function voltaArquivo() {
  # Caminho do arquivo server.xml e backup
  arquivo_server_xml="/opt/apache-tomcat-8.5.51/conf/server.xml"
  arquivo_backup_server_xml="$arquivo_server_xml.bak"

  # Verificar se o arquivo server.xml existe
  if [ ! -f "$arquivo_server_xml" ]; then
    echo "Erro: O arquivo $arquivo_server_xml não existe."
    exit 1
  fi

  # Verificar se o backup server.xml.bak existe
  if [ ! -f "$arquivo_backup_server_xml" ]; then
    echo "Erro: O arquivo de backup $arquivo_backup_server_xml não existe."
    exit 1
  fi

  # Remover o arquivo server.xml
  rm "$arquivo_server_xml"

  # Renomear server.xml.bak para server.xml
  cp "$arquivo_backup_server_xml" "$arquivo_server_xml"

  echo "O arquivo $arquivo_server_xml foi removido com sucesso e o backup $arquivo_backup_server_xml foi renomeado para $arquivo_server_xml."

}


function habilita_debug_remoto() {
  echo 'JPDA_OPTS="-agentlib:jdwp=transport=dt_socket,address=2234,server=y,suspend=n"' >${TOMCAT_HOME}/bin/setenv.sh
  echo 'CATALINA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=2234,server=y,suspend=n"' >>${TOMCAT_HOME}/bin/setenv.sh
  chmod 775 ${TOMCAT_HOME}/bin/setenv.sh
}

function verfica_e_trata_ambiente_de_desenvolvimento() {
  if [ -n "${ENVIRONMENT}" ]; then
    habilita_solr_para_acesso_remoto
    habilita_debug_remoto
  fi
}

function prepara_ambiente_rede() {
  echo "Adicionando hosts"
  echo "${SMTP_HOST_IP} smtp.apps.ibict.br" >> /etc/hosts
}

function inicia_servicos() {
  echo "Executando Cron"
  cron
}

echo "Iniciando a execução do container"

# Somente executa o bloco abaixo caso seja o primeiro "run" do container
if [[ ! -f "/opt/docker-build-complete" ]]; then
  echo "Primeira execuçao do container, preparando instalação"
  prepara_ambiente_rede
  prepara_tomcat
  instala_maven
  instala_ant

  compila_dspace
  instala_dspace_ou_atualiza_dspace
  declara_deploy_webapps
  remove_arquivos_instalacao
  cria_arquivo_indicador_conclusao_build
  verfica_e_trata_ambiente_de_desenvolvimento
  habilitar_acesso_ao_solr_somente_ips_internos
  # teste
else
  prepara_ambiente_rede
  prepara_tomcat
  instala_maven
  instala_ant
  compila_dspace
  instala_dspace_ou_atualiza_dspace
  remove_arquivos_instalacao
  verfica_e_trata_ambiente_de_desenvolvimento
  habilitar_acesso_ao_solr_somente_ips_internos
  # teste
fi

inicia_servicos

echo "Solicitando inicialização do Tomcat"
${TOMCAT_HOME}/bin/catalina.sh run

echo "Executando Cron"
cron
