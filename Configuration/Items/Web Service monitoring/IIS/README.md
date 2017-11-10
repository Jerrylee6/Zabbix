Windows Server IIS Monitor
====

说明
----
请根据Windows系统针对Web性能进行监控

> **例如:**

> - Windows操作系统的IIS服务状态

> - Windows操作系统的Web端口状态

> - Windows操作系统的Web服务,接收的字节数/秒

> - Windows操作系统的Web服务,当前连接数/分钟

### 部署步骤

#### 修改agent.conf配置文件支持

* LogFile=C:\Program Files\zabbix\log\zabbix_agentd.log
* Server=Zabbix_Server_IP
* ServerActive=Zabbix_Server_IP
* Hostname=WinSer_WebAPI01

#### 重新加载Agentd服务


#### WebUI配置

* 导入 Template_Windows_2008_R2_IIS_Servers.xml 模板
* 为主机关联模板

#### 测试log日志

