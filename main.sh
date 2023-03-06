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

    if ! [ -e preparacao/instalacao_dos_essenciais.sh ]; then
      mkdir preparacao
      wget -P preparacao/ "https://raw.githubusercontent.com/Jovanio-Junior/script_ambiente/main/instalacao_dos_essenciais.sh" --no-check-certificate
    fi
    cd preparacao
    chmod +x instalacao_dos_essenciais.sh
    #Instalação dos pacotes essenciais
    ./instalacao_dos_essenciais.sh $senha
    #verifica se tem erros na execução da instalação dos essenciais
    tem_erro=$(tail -n 1 output.txt)
    if (( $tem_erro == 0 )); then
        rm output.txt
    else
        #houve erros na instalação
        exit 1
    fi
    
    #Configurações iniciais (git, chave ssh e bitbucket)
    if ! [ -e preparacao/config_inicial.sh ]; then
      mkdir preparacao
      wget -P preparacao/ "https://raw.githubusercontent.com/Jovanio-Junior/script_ambiente/main/config_inicial.sh" --no-check-certificate
    fi
    chmod +x config_inicial.sh
    
    echo "final"
    echo $tem_erro
fi