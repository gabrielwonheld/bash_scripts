#! /usr/bin/env bash

modo_uso(){
    echo "
    Uso: ./portscan <ip> <primeira porta> <ultima porta>
    "
}

validar_ip(){
    local ip=$1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r a b c d <<< "$ip"
        if (( a <= 255 && b <= 255 && c <= 255 && d <= 255 )); then
            return 0
        fi
    fi
    return 1
}

validar_hping3(){
    if ! command -v hping3 &> /dev/null; then
        echo "hping3 não encontrado no seu sistema. Por favor, instale o programa."
        exit 1
    fi
}

validar_host(){
    echo "Verificando host..."

    if ping -c 2 "$1" &> /dev/null; then
        echo "-------------------"
        echo "Host ativo na rede"
        echo "-------------------"
    else
        echo "-------------------"
        echo "Host inativo na rede"
        echo "-------------------"
        exit 1
    fi
}

validar_parametros(){
    if [ $# -ne 3 ]; then
        echo "Error: O programa precisa de 3 argumentos."
        modo_uso
        exit 1
    fi

    if ! validar_ip "$1"; then
        echo "Error: Endereço IP inválido."
        modo_uso
        exit 1
    fi

    if ! [[ $2 =~ ^[0-9]+$ && $3 =~ ^[0-9]+$ ]] || (( $2 < 1 || $2 > 65535 || $3 < 1 || $3 > 65535 || $2 > $3 )); then
        echo "Error: O número da porta não é válido."
        exit 1
    fi
}

portscan(){
    inicio=$2
    fim=$3

    echo "Iniciando portscan de $inicio a $fim..."
    for port in $(seq "$inicio" "$fim"); do
        sudo hping3 -S -p "$port" -c 1 "$1" 2> /dev/null | grep "flags=SA" && echo "Porta $port: ABERTA"
    done
}

main(){
    validar_hping3
    validar_parametros "$@"
    validar_host "$1"
    portscan "$1" "$2" "$3"
}

main "$@"
