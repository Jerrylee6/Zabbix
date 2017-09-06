#!/bin/bash
#
# chkconfig: - 90 10
# description:      build PHP script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            build_php.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         13.3.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
cd /packages/release/$1                         ###Reference group_vars/all And Reference roles/php/tasks/main.yml

./configure \
--enable-fpm --enable-bcmath \
--enable-ctype --enable-sockets \
--enable-mbstring --with-gettext \
--with-gd --with-jpeg-dir \
--with-freetype-dir \
--with-mysqli

make && make install