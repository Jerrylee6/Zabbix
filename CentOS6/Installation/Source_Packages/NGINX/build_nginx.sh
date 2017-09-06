#!/bin/bash
#
# chkconfig: - 90 10
# description:      build nginx script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            build_nginx.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         13.3.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1                         ###Reference group_vars/all And Reference roles/nginx/tasks/main.yml

./configure --prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-http_ssl_module \
--with-http_realip_module

make && make install