#!/bin/bash
senha=$1
# Define array de pacotes a serem instalados
pacotes=(
  curl
  wget
  gnupg2
  git
  git-lfs
  build-essential
  unzip
  pandoc
  libglib2.0-0
  zlib1g-dev
  libssl-dev
  libreadline-dev
  libyaml-dev
  libsqlite3-dev
  sqlite3
  libxml2-dev
  libxslt1-dev
  libcurl4-openssl-dev
  software-properties-common
  libffi-dev
  unixodbc-dev
  libgssapi-krb5-2
  libbz2-dev
  python3-dev
  python3-venv
  python3-pip
  python-is-python3
  libsm6
  libxext6
  libxrender1
  ffmpeg
  dos2unix
  openssh-server
  gcc
  g++
)

# Instale cada pacote no array
total_pacotes=${#pacotes[@]}
contador=0
# echo $total_pacotes
erro_install=0
for pacote in "${pacotes[@]}"
do
  ((contador++))
  if ! dpkg -s "$pacote" > /dev/null 2>&1; then
    echo $senha | sudo -S apt install "$pacote" -yqq > /dev/null 2>&1
    # Verifica o código de retorno do comando anterior
    if ! [ $? -eq 0 ]; then
        erro_install++
    fi
  fi
  progresso=$((contador * 100 / total_pacotes))
  echo -ne "Status da Instalação: [$progresso% de 100%] [erros: $erro_install]\r"
done

#retorna se foram encontrados erros
echo $erro_install > output.txt