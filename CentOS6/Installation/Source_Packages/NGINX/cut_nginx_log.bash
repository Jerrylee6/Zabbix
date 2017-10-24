#!/bin/bash
#
# chkconfig: - 90 10
# description:      cut nginx_log script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            cut_nginx_log.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         23.10.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions

# Variables
DATE=`date +%Y%m%d`
OLDDATE=`date +%Y%m%d -d ' - 30 days'`
PIDFILE='/var/run/nginx.pid'
NGINX_LOG_PATH='/var/log/nginx'
NGINX_LOG_BACK_PATH='/var/log/nginx'
ACCESS_LOG_FILE='host.access.log'
ERROR_LOG_FILE='host.error.log'

[ ! -d "${NGINX_LOG_BACK_PATH}/${OLDDATE}" ] || rm -rf ${NGINX_LOG_BACK_PATH}/${OLDDATE}

mkdir -p ${NGINX_LOG_BACK_PATH}/${DATE}
mv ${NGINX_LOG_PATH}/${ACCESS_LOG_FILE} ${NGINX_LOG_BACK_PATH}/${DATE}/${ACCESS_LOG_FILE}
mv ${NGINX_LOG_PATH}/${ERROR_LOG_FILE} ${NGINX_LOG_BACK_PATH}/${DATE}/${ERROR_LOG_FILE}

kill -USR1 `cat ${PIDFILE}`