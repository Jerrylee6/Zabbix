<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '{{ Zabbix_DB_Host }}';
$DB['PORT']     = '{{ Zabbix_DB_Port }}';
$DB['DATABASE'] = '{{ Zabbix_DB_DBName }}';
$DB['USER']     = '{{ Zabbix_DB_User }}';
$DB['PASSWORD'] = '{{ Zabbix_DB_Pwd }}';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '{{ Zabbix_DB_Host }}';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
