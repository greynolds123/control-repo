#!/bin/bash
#
#
# Author: Glynn D. Reynolds
# Type: Manage Selinux Boolean
# Date: 12/10/2013
# Time: 21:55:03

###########################

# Script Function

read -p "list the current status for?(ex: http, cobbler) " SES


read -p "Set the boolen express to(ex: 0 or 1 ) "  be

for i in $(/usr/sbin/sestatus -b | grep $SES);

      do

  case $be in

  0) setsebool -P $i=$be; continue;;
  1) setsebool -P $i=$be; continue;;
  *) echo "$be is not a 0 or a 1";;

  esac;
      done

exit 0

