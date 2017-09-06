#!/bin/bash
#
# chkconfig: - 90 10
# description:      build MySQL script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            build_mysql.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         13.3.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1                         ###Reference group_vars/all And Reference roles/mysql/tasks/main.yml

cmake \
-DCMAKE_INSTALL_PREFIX=/safe/mysql \
-DMYSQL_DATADIR=/data/MySQLDB \
-DSYSCONFDIR=/etc \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DWITH_DEBUG=0 \
-DENABLED_LOCAL_INFILE=1

make && make install