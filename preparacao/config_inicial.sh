# #configuração do git
#1 = user ; 2 = email
git config --global user.name $1
git config --global user.email $2

#chave ssh bitbucket
fun_opcao1() {
    sleep 3
    echo -e "Adicione a pasta .ssh (/home/$USER/.ssh) os arquivos \n1: id_rsa \n2: id_rsa.pub"
    sleep 5
    echo "em cerca de 5 segundos o diretorio citado acima ira abrir, adicione os arquivos 1 e 2 e depois volte ao terminal"
    cd /home/$USER/.ssh
    explorer.exe .
    printf "Quando acabar o processo digite: ${RED}finalizado"
    read opcao2
    if [[ "${opcao2}" == "finalizado" ]]; then
        printf " "
    fi
}
fun_opcao2e3() {
    if [ -d "/home/$USER/.ssh" ]; then
        echo "directory \home\${USER}\.ssh\ exists"
    else
        mkdir .ssh
    fi
    Passphrase=$(
        tr -dc A-Za-z0-9 </dev/urandom | head -c 8
        echo ''
    )
    echo -e "\n" | ssh-keygen -t rsa -b 4096 -C $2 -P $Passphrase -q
    printf "\nfoi gerado dois arquivos ${RED} id_rsa e id_rsa.pub\n"
    sleep 4
    echo "em cerca de 10 segundos ira abrir o diretorio onde eles estão localizados"
    sleep 1
    printf "\nabra o arquivo ${RED} id_rsa.pub ${NC} em um bloco de notas e copie ate as os dois sinais de igualdade antes do seu email"
    sleep 5
    echo -e "\nexemplo de como é: .............NCILItu9xt2GZMf52RPh5cswVBV44jvdgw== jovanio.galvao@minervafoods.com"
    sleep 2
    echo "exemplo do que devo copiar: .............NCILItu9xt2GZMf52RPh5cswVBV44jvdgw=="
    sleep 2
    cd /home/$USER/.ssh
    explorer.exe .
    printf "\nQuando acabar o processo digite: ${RED}finalizado\n"
    read opcao2
    if [[ "${opcao2}" == "finalizado" ]]; then
        echo "em cerca de 4 segundos ira abrir a pagina do bitbucket"
        sleep 4
        cmd.exe /C start https://bitbucket.org/account/settings/ssh-keys/
        printf "${Green}caso precise de logar, entre e depois clique no seguinte link${NC}"
        printf "\n${RED}https://bitbucket.org/account/settings/ssh-keys/"
        printf "\n1: clique em ${RED}Adicionar chave${NC} \n2: em ${RED}Label${NC} defina um nome para esta chave \n3: em ${RED}Key${NC} adicione a chave que copiou na etapa acima\n"
        read -p "Quando acabar precione enter para continuar " -n1 -s
    fi
}
clear
echo "Ja possui chave ssh cadastrada no bitbucket?"
opcao=0
while (($opcao >= 0)); do
    # body
    sleep 2
    echo -e "digite \n1: sim ja possuo uma chave e tenho ela salva \n2: não possuo uma chave ssh (gera uma nova) \n3: possuo uma chave mas quero gerar uma nova"
    read opcao
    if (($opcao == 1)); then
        if [ -d "/home/$USER/.ssh" ]; then
            echo "directory \home\${USER}\.ssh\ exists"
        else
            mkdir .ssh
        fi
        fun_opcao1
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_rsa
        opcao=-1
    else
        if (($opcao == 2)); then
            fun_opcao2e3
            opcao=-1
        else
            if (($opcao == 3)); then
                fun_opcao2e3
                opcao=-1
            else
                opcao=-1
            fi
        fi
    fi
done