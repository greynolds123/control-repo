#!/bin/bash
#
#
# Author: Glynn D. Reynolds
# Type: OS cache cleaner
# Date: 11/24/2016
# Time: 23:27:47

###########################

# Script Function

sync; echo 3 > /proc/sys/vm/drop_caches

exit 0

