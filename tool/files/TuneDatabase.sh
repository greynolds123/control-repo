#!/bin/bash
#
#
# Author: Glynn D. Reynolds
# Type: Tune Databases'
# Date: 11/14/2016
# Time: 23:45:31

###########################

# Postgres command to tune the database
aac='/bin/su - pe-postgres -s /bin/bash -c "vacuumdb -z --verbose pe-activity"'
cvac='/bin/su - pe-postgres -s /bin/bash -c "vacuumdb -z --verbose pe-classifier"'
pvac='/bin/su - pe-postgres -s /bin/bash -c "vacuumdb -z --verbose pe-puppetdb"'
rvac='/bin/su - pe-postgres -s /bin/bash -c "vacuumdb -z --verbose pe-rbac"'
ovac='/bin/su - pe-postgres -s /bin/bash -c "vacuumdb -z --verbose pe-orchestrator"'
server='/root/Server_List'


# Script Function


for s in $(gawk -F: '{print}' < "$server");

   do

ssh-copy-id $s &&  $avac

sleep 2

ssh $s $cvac 

sleep 2

ssh $s $pvac 

sleep 3

ssh $s $rvac

sleep 3

ssh $s $ovac;

  done


exit 0

