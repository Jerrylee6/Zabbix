#!/bin/bash
#
# chkconfig: - 90 10
# description:      build zabbix Server script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            build_zabbix_server.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         13.9.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1

./configure \
--with-libcurl \
--with-ssh2 \
--with-net-snmp \
--enable-server \
--enable-agent \
--with-jabber=/usr/local \
--with-mysql=/safe/mysql/bin/mysql_config

make && make install