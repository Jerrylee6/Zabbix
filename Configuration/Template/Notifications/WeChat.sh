#!/bin/bash
#
# chkconfig: - 90 10
# description:      WeChat Notification Script
#                   System:     CentOS 6 x64
#                   Version:    1.0
#
# @name:            WeChat.sh
# @author:          51inte <51inte@hotmail.com>
# @created:         8.7.2017
# @Script Version:  v1.0
#
#
# Source function library.
. /etc/init.d/functions
# Variables
CropID='ww6e114e3d6xxxx'										##企业微信"CorpID"号
Secret='VnKTqJWtG7-k74bmJQc7Q_jdfkx5VE7fxxxxxxx'				##新添加的企业应用中的"Secret"号
GURL=https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID\&corpsecret=$Secret
Gtoken=$(/usr/bin/curl -s -G $GURL | awk -F\" '{print $10}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"
function body() {
        local int AppID=1000002									#企业号中的应用 ID
        local UserID=$1											#部门成员、Zabbix中定义的微信接收者
#        local PartyID=2										#部门ID、定义范围(组内成员都可接收到消息)
        local Msg=$(echo "$@" | cut -d " " -f3-)
	printf '{\n'
	printf '\t"touser": "'"$1"'",\n'
	printf '\t"toparty": "'"$PartyID"'",\n'
	printf '\t"msgtype": "text",\n'
	printf '\t"agentid": "'"$AppID"'",\n'
	printf '\t"text": {\n'
	printf '\t\t"content": "'"$Msg"'"\n'
	printf '\t},\n'
	printf '\t"safe": "0"\n'
	printf '}\n'
}
/usr/bin/curl --data-ascii "$(body $1 $2 $3)" $PURL

