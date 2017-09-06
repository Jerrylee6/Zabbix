#!/bin/bash
#
# chkconfig: - 90 10
# description:      build zabbix client script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            install_build.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         13.3.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1

./configure \
--with-mysql \
--with-libcurl \
--with-ssh2 \
--with-net-snmp \
--enable-server \
--enable-agent \
--enable-java \
--with-jabber=/usr/local

make && make install