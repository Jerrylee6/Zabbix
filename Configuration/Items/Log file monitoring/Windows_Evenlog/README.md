Windows Evenlog Monitor
====

说明
----
请根据你的操作系统选择需要监控的日志文件进行监控

> **例如:**

> - Windows操作系统的Evenlog日志

### 部署步骤

#### 修改agent.conf配置文件支持

* LogFile=C:\Program Files\zabbix\log\zabbix_agentd.log
* Server=Zabbix_Server_IP
* ServerActive=Zabbix_Server_IP
* Hostname=WinSer_WebAPI01

#### 重新加载Agentd服务


#### WebUI配置

* 导入 Template_Windows_Evenlogs.xml 模板
* 为主机关联模板

#### 测试log日志

