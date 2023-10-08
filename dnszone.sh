#!/bin/bash


echo "--------------"
echo -e "DNS ZONE"
echo "--------------"

if [ $1 == "" ];then
        echo "digite o DNS desejada para ser scaneada"
else

	for server in $(host -t ns $1 | cut -d " " -f 4);do

        	host -l -a $1 $server

	done
fi

