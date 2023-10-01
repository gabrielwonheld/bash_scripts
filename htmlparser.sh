#!/bin/bash

if [ $1 == "" ];then
	echo "digite a url desejada para ser scaneada"
else
	wget $1

	#capturando o dominio do arquivo dominio.txt

	cat index.html | grep "href=" | cut -d '"' -f 2 | cut -d '/' -f 3 | grep "\." | sort -d | uniq -u >> dominio.txt

	echo -e "HOST \t\t\t\t\tIP"

	# capturando o IP do domínio
	for host in $(cat dominio.txt);do

		ip=`host $host | grep "has address" | cut -d ' ' -f 4` #  >> ip.txt
		echo -e "$host \t$ip"
	done
fi


#echo "IP		dominio"
#echo -e "$(cat ip.txt)"
#echo -e "$(cat dominio.txt)"

rm dominio.txt index.html


