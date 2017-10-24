#!/bin/bash
export zabbixemailto="$1"
export zabbixsubject="$2"
export zabbixbody="$3"
zabbixbody=`echo $zabbixbody|tr '\r' '\n'`
cat << EOF | mail -s "$2" $1 
$zabbixbody
EOF
