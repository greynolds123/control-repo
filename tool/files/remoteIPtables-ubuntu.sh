#!/bin/bash

IP=~root/myserver.txt

cwd='/sbin/iptables'

myip=~root/myserver.txt

iptsave='/sbin/iptables-save'

#iptrestart='/sbin/service iptables restart'

###########################
#collecting IP 

/sbin/ifconfig | grep '\<inet\>' | sed -n '1p' | tr -s ' ' | cut -d ' ' -f3 | cut -d ':' -f2 > ~root/myserver.txt

###########################

# Script function

   if apt-get install iptables

      then

 for d in $(awk -F: '{print}' < "$IP");

      do

   echo $d;

 ssh-copy-id root@$d

       done

    for i in $(awk -F: '{print}' < "$myip");

     do

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 22 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 443 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 25150 -j ACCEPT
 
 ssh root@$d  $cwd -I INPUT  -p udp -s $i --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 53 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 80 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 749 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 88 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 389 -j ACCEPT
 
 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 5222 -j ACCEPT
 
 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 5432 -j ACCEPT

 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 25151 -j ACCEPT
 
 ssh root@$d  $cwd -I INPUT  -p tcp -s $i --dport 69 -j ACCEPT
 
 ssh root@$d  $cwd -I INPUT  -p udp -s $i --dport 69 -j ACCEPT;

       done

   for f in $(awk -F: '{print}' < "$myip");

    do

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 22 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 443 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 53 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 80 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 749 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 88 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p tcp -s $f --dport 389 -j ACCEPT

 ssh root@$d  $cwd -I FORWARD  -p udp -s $f --dport 69 -j ACCEPT;

done

   for o in $(awk -F: '{print}' < "$myip");

    do

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 22 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 443 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p udp -s $o --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 53 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 80 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 749 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 88 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 389 -j ACCEPT
 
 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 5222 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 5432 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 25151 -j ACCEPT
 
 ssh root@$d  $cwd -I OUTPUT  -p tcp -s $o --dport 69 -j ACCEPT

 ssh root@$d  $cwd -I OUTPUT  -p udp -s $o --dport 69 -j ACCEPT;

  done

 ssh root@$d $iptsave

 #ssh root@$d $iptrestart

fi

      exit 0
