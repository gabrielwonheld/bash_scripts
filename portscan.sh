#!/bin/bash

#for host in {1..254};do
echo "portscan"
	for port in {1..100};do

		hping3 -S -p $port -c 1 $1 2> /dev/null | grep "flags=SA"
	done
#done
