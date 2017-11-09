Overview
===

To configure e-mail as the delivery channel for messages, you need to configure e-mail as the media type and assign specific addresses to users.


##Function
---
You can do the following:

*.	Send mail notification


##Install mail-client
---

`yum install mail`


##Highlihgt Syntax
---

```
bash:cat /etc/mail.rc
set bsdcompat
set from=user@vcyber.com
set smtp=smtp.vcyber.com
set smtp-auth-user=user@vcyber.com
set smtp-auth-password=******
set smtp-auth=login
```

##Configure ZABBIX access scripts
---

1)Write `mail.sh` into your scripts path (like: `zabbix/share/zabbix/alertscripts`) on your Zabbix Server hosts.

1.1)Zabbix Version 2.2.* support

```bash:mail.sh
#!/bin/bash
echo "$3" | mail -s "$2" "$1"
```

1.2)Zabbix Version 3.* support

```
bash:mail.sh
#!/bin/bash
export zabbixemailto="$1"
export zabbixsubject="$2"
export zabbixbody="$3"
zabbixbody=`echo $zabbixbody|tr '\r' '\n'`
cat << EOF | mail -s "$2" $1 
$zabbixbody
EOF
```

2)In script path (`zabbix/share/zabbix/alertscripts`) do:

```
chmod +x mail.sh
chmod +s mail.sh
```

3)Test Script

  ~#bash mail.sh user@domail.com subject message

4)Activate the script to store the path in zabbix_servce.conf 

  `AlertScriptsPath=/usr/local/share/zabbix/alertscripts`

5)WebUI    Configure

5.1)`Administration`-->`User groups`-->`Zabbix administrators`-->`Permissions`

5.2)`Administration`-->`Media types`-->`Create media type`
    
	*    Name：`mail`
    *    Type：`Script`
    *    Script name：`mail.sh`

5.3)`Configuration`-->`Actions`-->`Create action`
    
	*    Name：`Action_Name`
    *    Default subject：`In the IIS service, the {ITEM.NAME} site is stopped. On the {HOST.NAME}`
    *    Default message：

```
Problem:

Event ID: {EVENT.ID}
Event value: {EVENT.VALUE} 
Event status: {EVENT.STATUS} 
Event time: {EVENT.TIME}
Event date: {EVENT.DATE}
Event age: {EVENT.AGE}
Event acknowledgement: {EVENT.ACK.STATUS} 
Event acknowledgement history: {EVENT.ACK.HISTORY}
```

*)Recovery message：

```
Recovery:

Recovery: 
Event ID: {EVENT.RECOVERY.ID}
Event value: {EVENT.RECOVERY.VALUE} 
Event status: {EVENT.RECOVERY.STATUS} 
Event time: {EVENT.RECOVERY.TIME}
Event date: {EVENT.RECOVERY.DATE}
```

That is all :)
