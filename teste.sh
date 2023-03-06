#script para Ubuntu 20.04.*
VERSAO_SCRIPT='0.1'
UBUNTU_SUPORTADO='20.04'
VERSAO_UBUNTU=$(lsb_release -sr)
RED='\033[0;31m'
NC='\033[0m'
Green='\033[0;32m'

sleep 3
echo "Script versão ${VERSAO_SCRIPT}, feito para configurar o ambiente de desenvolvimento para o projeto Hera"
sleep 3
echo "Verificando a compartibilidade do SO"
if [[ "${VERSAO_UBUNTU}" != "${UBUNTU_SUPORTADO}" ]]; then
    # lsb_release -a
    sleep 1
    echo "Esse script foi feito para o Ubuntu 20.04.* e a versão atual é ${VERSAO_UBUNTU}"
    sleep 1
    echo "Pode haver diversar incompartibilidaes, recomendados a instalação do Ubuntu 20.04"
    echo -e "Para ver as informações do SO atual digite: \n1:sim \n2: (finalizar script)"
    read opcao
    if (($opcao == 1)); then
        lsb_release -a
    fi
else
    sleep 2
    echo -e "Iniciando Instalação\n"
    echo "Digite sua senha: "
    read senha
    echo "digite seu nome de usuario do git: "
    read usuario_git
    echo "digite seu e-mail da minerva: "
    read email
    clear
    sleep 3

    # #Instalações iniciais
    # echo $senha | sudo -S apt update
    # echo $senha | sudo -S apt upgrade -y
    # echo $senha | sudo -S apt install -y curl wget gnupg2 git git-lfs build-essential unzip pandoc libglib2.0-0
    # echo $senha | sudo -S apt install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3
    # echo $senha | sudo -S apt install -y libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
    # echo $senha | sudo -S apt install -y unixodbc-dev libgssapi-krb5-2 libssl-dev libcurl4-openssl-dev libbz2-dev
    # echo $senha | sudo -S apt install -y python3-dev python3-venv python3-pip python-is-python3
    # echo $senha | sudo -S apt install -y libsm6 libxext6 libxrender1 ffmpeg dos2unix openssh-server
    # echo $senha | sudo -S apt install -y gcc g++

    # #configuração do git
    # git config --global user.name $usuario_git
    # git config --global user.email $email
 
    
    chmod 600 /home/$USER/.ssh
    #aws
    echo $senha | sudo -S curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    echo $senha | sudo -S unzip awscliv2.zip
    echo $senha | sudo -S unzip ./aws/install --update
    echo $senha | sudo -S unzip rm -rf awscliv2.zip
    echo $senha | sudo -S unzip rm -rf ./aws

    #MSSQL
    echo $senha | sudo -S curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
    echo $senha | sudo -S wget -P /etc/apt/sources.list.d -O mssql-release.list https://packages.microsoft.com/config/ubuntu/20.04/prod.list
    echo $senha | sudo -S apt update
    echo $senha | sudo -S ACCEPT_EULA=Y
    echo $senha | sudo -S apt install -y msodbcsql17 mssql-tools powershell
    echo $senha | sudo -S echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >>~/.bash_profile
    echo $senha | sudo -S echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >>~/.bashrc

    # DOWNGRADE SSL TO CONNECTION DB's minerva MSSQL
    cd /home/$USER/
    echo $senha | sudo -S curl -O https://www.openssl.org/source/openssl-1.1.1.tar.gz
    echo $senha | sudo -S tar -zxf openssl-1.1.1.tar.gz
    echo $senha | sudo -S cd openssl-1.1.1
    echo $senha | sudo -S ./config
    echo $senha | sudo -S make
    echo $senha | sudo -S make install
    echo $senha | sudo -S rm -rf /openssl-1.1.1*
    echo $senha | sudo -S ln -sf /$USER/local/lib/libcrypto.so /$USER/local/lib/libcrypto.so.1.0.0
    echo $senha | sudo -S ln -sf /$USER/local/lib/libssl.so /$USER/local/lib/libssl.so.1.0.0
    echo $senha | sudo -S ln -sf /$USER/local/lib/libssl.so.1.0.0 /opt/microsoft/powershell/7/libssl.so.1.0.0
    echo $senha | sudo -S ln -sf /$USER/local/lib/libssl.so.1.0.0 /opt/microsoft/powershell/7/libssl.so.1.0.0

    #anaconda3
    echo $senha | sudo -S wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
    echo $senha | sudo -S chmod +x Anaconda3-2022.10-Linux-x86_64.sh
    ./Anaconda3-2022.10-Linux-x86_64.sh -b -p /home/jovanio/anaconda3
    export PATH="home/$USER/anaconda3/bin:$PATH"
    source ~/anaconda3/etc/profile.d/conda.sh
    conda init

    #criando ambientes
    clear
    sleep 4
    echo "criando ambientes"
    printf "1: arion_api\n 2: arion_optimizer"
    conda create -n arion_optimizer python=3.8
    conda create -n arion_api python=3.8

    #dbatools
    pwsh -Command Install-Module dbatools -RequiredVersion 1.0.153 -AcceptLicense -PassThru -Force -SkipPublisherCheck
    echo $senha | sudo -S ldconfig

    echo -e "Pronto seja feliz"
    echo -e "${RED}Pronto seja feliz"
fi
