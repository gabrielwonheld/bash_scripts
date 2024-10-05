#! /usr/bin/env bash

#vars

ativos=""
inativos=""

verde="\033[0;32m"
vermelho="\033[0;31m"
reset="\033[0m"


modo_uso(){
	
	
	echo "Modo de Uso:

[cmd] [faixa de rede]  [inicio] [fim]
rping   192.168.0 	  1 	 10"
}




#verificações

validar_ip(){


	local ip=$1
	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

	IFS='.' read -r a b c <<< "$ip"
	if (( a <= 255 && b <= 255 && c <= 255 )); then
		return 0
	fi

	fi
	return 1


}

validar_argumentos(){

	if ! validar_ip "$1"; then

		echo "$(modo_uso)"; exit 1
		
	fi


	[ $# -ne 3 ] && echo "O script necessita de 3 valores!
	$(modo_uso)" && exit 1

	[ $2 -gt $3 ] && echo "O valor final do range não pode ser maior que o inicio do range!" && exit 1

}

rping(){


	local mascara=$1
	local inicio=$2
	local fim=$3


	for i in $(seq $inicio $fim); do

	        ip=$mascara.$i
	        ping -c 1 $ip &> /dev/null

	        if [ $? -eq 0 ];then
	                 ativos+="$ip ${verde}Ativo${reset}"$'\n'

	        else
	                 inativos+="$ip ${vermelho}inativo${reset}"$'\n'
	        fi
	        echo -n "[$i] "
	done


	echo -e "\n\nHosts Ativos:\n$ativos"
	echo -e "Hosts Inativos:\n$inativos"
	exit 0


}

main(){

	validar_argumentos "$@"

	rping "$1" "$2" "$3"
}

main "$@"