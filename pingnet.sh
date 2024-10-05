#!/bin/bash

if [ "$1" == "" ]
then

echo "insira uma rede para ser escaneada"

else
	for host in {1..254};do
		ping -c 1 $1.$host | grep "64 bytes" | cut -d " " -f 4 #>> onlyip.txt
done
fi
