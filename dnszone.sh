#!/bin/bash

echo -e " DNSZONE"


for server in $(host -t ns $1 | cut -d " " -f 4);do

        host -l -a $1 $server

done


