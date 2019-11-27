# About Granfana与Zabbix的结合

本素材来源于"https://grafana.com/grafana/download?platform=linux"

## 在 CentOS 操作系统中安装 Granfana

1.  下载 Granfana 安装包

    wget https://dl.grafana.com/oss/release/grafana-6.0.0-1.x86_64.rpm 
	sudo yum localinstall grafana-6.0.0-1.x86_64.rpm 

2.   下载并更新CentOS字符集

	sudo yum install initscripts fontconfig
	
3.   更新本地yum仓库

	$ cat /etc/yum.repos.d/grafana.repo
	
		[grafana]
		name=grafana
		baseurl=https://packages.grafana.com/oss/rpm
		repo_gpgcheck=1
		enabled=1
		gpgcheck=1
		gpgkey=https://packages.grafana.com/gpg.key
		sslverify=1
		sslcacert=/etc/pki/tls/certs/ca-bundle.crt
		
4.  yum仓库安装
	
	$ sudo yum install grafana
	
5.  安装包细节描述

    二进制执行文件位于: /usr/sbin/grafana-server
	
    将ini.d脚本文件拷贝于: /etc/init.d/grafana-server
	
    将默认文件(环境变量)安装到: /etc/sysconfig/grafana-server
	
    将配置文件复制到: /etc/grafana/grafana.ini
	
    安装systemd服务（如果systemd可用）： grafana-server.service
	
    日志默认配置使用位于: /var/log/grafana/grafana.log
	
    sqlite3数据库默认配置指定位于: /var/lib/grafana/grafana.db

6.  配置为虽系统系统
	
	$ sudo chkconfig --add grafana-server
	
	$ sudo chkconfig grafana-server on

7.  服务端图像呈现

	$ yum install fontconfig
	$ yum install freetype*
	$ yum install urw-fonts

8.  通过浏览器访问http://localhost:3000 ,默认用户和密码均为: admin

	<a href="/login">Found</a>.
	
## 配置 Granfana

1.  安装插件

	$ grafana-cli plugins install alexanderzobnin-zabbix-app
	
2.  重启服务
	
	$ service grafana-server restart
	
3.  配置说明参考

	http://192.168.84.242:3000/plugins/alexanderzobnin-zabbix-app/edit?tab=readme