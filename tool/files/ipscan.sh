#!/bin/bash
# Author: Glynn D. Reeynolds
# Type: Host scan
# Date: 03/22/2017
# Time: 13:29:22

###########################

# Script Function

# List of networks
networks="/root/networks.txt"

###########################

for s in $(gawk -F: '{print}' < "$networks");

    do

echo $s

nmap -sT $s -oG -iflist -A;

    done


exit 0

