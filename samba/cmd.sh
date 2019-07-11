#!/bin/bash

bundle exec rake validate && bundle exec rake lint || bundle exec rake lint | grep -v 'variable contains a dash on line' | grep  'ERROR\|WARNING' && exit 1 || exit 0
