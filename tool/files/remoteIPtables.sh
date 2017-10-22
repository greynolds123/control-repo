#!/bin/bash
#
#
# Author: Glynn D. Reynolds
# Type: To Add an IPtables Firewall
# Date: 11/11/2014
# Time: 11:31:26
###########################

IP='/root/myserver.txt'

cwd='/sbin/iptables'

myip='/root/myserver.txt'

iptsave='/sbin/service iptables status'

iptrestart='/sbin/service iptables restart'

###########################
#collecting IP

/sbin/ifconfig | grep '\<inet\>' | sed -n '1p' | tr -s ' ' | cut -d ' ' -f3 | cut -d ':' -f2 > ~root/myserver.txt

read -p "Set ssh key for root? [y/n] " rk

    if [ $rk = y ]; then

  cd ~root && ssh-keygen -t rsa

    if [ $rk = n ]; then

      exit 1
fi
 fi


###########################

# Script Function


   if yum install iptables

      then

 for d in $(gawk -F: '{print}' < "$IP");

      do

   echo $d;

  ssh-copy-id root@$d

       done




 for i in $(gawk -F: '{print}' < "$myip");

     do

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 22 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 443 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p udp -s $i --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p udp -s $i --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 53 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 80 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 82 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8080 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8082 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8081 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8082 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8081 -j ACCEPT

ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8082 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 749 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 88 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 389 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 5222 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 5432 -j ACCEPT

ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 69 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p udp -s $i --dport 69 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8009 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 5000 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p udp -s $i --dport 8009 -j ACCEPT

 ssh root@$d  $cwd -A INPUT  -p tcp -s $i --dport 8000 -j ACCEPT

 ssh root@$d  $cwd -A INPUT -m limit --limit 15/minute -j LOG --log-level 7 --log-prefix "Dropped";

       done

   for f in $(gawk -F: '{print}' < "$myip");

    do

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 22 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 443 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 53 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 80 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 8080 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 8082 -j ACCEPT

 ssh root@$d  $cwd -A FORWARD  -p tcp -s $f --dport 8000 -j ACCEPT


done

   for o in $(gawk -F: '{print}' < "$myip");

    do

ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 22 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8140 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 61613 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 443 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8443 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p udp -s $o --dport 25150 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p udp -s $o --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 53 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 80 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 82 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8081 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8082 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 749 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 88 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 389 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 5222 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 5432 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 25151 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 69 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8009 -j ACCEPT

ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 5000 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p udp -s $o --dport 8009 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT  -p tcp -s $o --dport 8000 -j ACCEPT

 ssh root@$d  $cwd -A OUTPUT -m limit --limit 15/minute -j LOG --log-level 7 --log-prefix "Dropped";

  done

 ssh root@$d $iptsave

 ssh root@$d $iptrestart

fi

   exit 0

