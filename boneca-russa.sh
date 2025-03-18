#!/usr/bin/env bash



arquivos="$1"

function compactar(){

    local entrada="$arquivos"
    local nome senha anterior=""

    for index in {1..5};do
        
        senha=$RANDOM
        nome="${senha}.7z"

        echo "[*] Criando o arquivo: $nome com a senha:$senha"

        if 7z a "$nome" -p"$senha" "$entrada" > /dev/null;then

            echo "[v] $nome criado com sucesso"
            
            if [[ -n "$anterior" ]];then

                echo "[V] Excluindo o arquivo anterior: $anterior"

                rm -f "$anterior"
            fi
            anterior="$nome"
        else

            echo "[x] Falha ao criar $nome"
            exit 1
        fi
        
        entrada="$nome"

    done
}

function descompactar(){
    local arquivo="$arquivos"
    local anterior=""
    local arquivo_senha=$(echo "$arquivo" | awk -F '.' '{print $1}')
    # local arquivo_senha="$arquivo_primeira_senha"

    while true;do

        #arquivo=$(ls -1 | grep -E ".7z$")
        local novo_arquivo=$(7z -slt l "$arquivo" | grep 'Path' | awk 'NR!=1' |  awk '{print $3}')
        echo "$arquivo"
        if [[ -z "$novo_arquivo" ]];then

            echo "Finalizando o script";exit 0
        fi

        if 7z x -p"$arquivo_senha" "$arquivo" | grep -E ".7z$" | awk -F '.' '{print $1}' >/dev/null 2>&1;then

            echo "[*] Descompactando o arquivo: $arquivo"

            arquivo="$novo_arquivo"
            arquivo_senha=$(echo "$arquivo" | awk -F '.' '{print $1}')

            if [[ -n "$anterior" ]];then

                echo "[V] Excluido arquivo $anterior"
                rm -f "$anterior"

            fi

            anterior="$arquivo"
            arquivo="$novo_arquivo"
        
        else

            echo "[X] Falha ao extrair $arquivo com senha $arquivo_senha"
            exit 1
        
        fi
    done

}

case "$2" in

    x)
        descompactar
        ;;
    a)
        compactar
        ;;
    *)
        Mensagem="Modo de uso: $0 arquivo x/a"
esac