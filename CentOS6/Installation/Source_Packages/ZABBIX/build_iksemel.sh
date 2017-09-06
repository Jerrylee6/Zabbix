#!/bin/bash
#
# chkconfig: - 90 10
# description:      build iksemel script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            build_iksemel.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         5.9.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1

./configure

make && make install