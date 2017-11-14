Linux Server NGINX Monitor
===

说明
----
请根据Linux系统针对NGINX性能进行监控,环境需求："python","htpasswd","NGINX"

> **NGINX KEY的取值详解:**

1. Accepted connections 			表示: NGINX接受的连接数
2. Accepted connections\min			表示：NGINX在1分钟内接收的连接数
3. Active connections				表示：NGINX当前活跃的连接数又称 "并发数"
4. Keepalive connections			表示：客户端与NGINX保持连接数
5. Handled requests					表示：NGINX处理的请求总数
6. Response code 500 per minute		表示：客户端失败的请求总数


### 部署步骤
----

1. 安装环境需求

		yum install python htpasswd
		htpasswd -c /usr/local/nginx/conf/htpasswd user
		New password: pass
		Re-type new password: pass

2. 将"zbx_nginx_stats.py" 脚本拷贝到"/usr/local/etc/zabbix_agentd.conf.d/" 目录下

3. 修改"zbx_nginx_stats.py" 内容

		zabbix_host = '192.168.84.242'   		# Zabbix server IP
		zabbix_port = 10051                     # Zabbix server port
		hostname = 'CenNGINX01'   	            # Name of monitored host, like it shows in zabbix web ui
		time_delta = 1                          # grep interval in minutes

4. 开启NGINX的StubStatus模块的配置

		# StubStatus on Zabbix Monitor
		location /nginx_stat {
			stub_status              on;
			access_log               /var/log/nginx/nginx_stat.log;
			auth_basic               "nginx_stat";
			auth_basic_user_file     /usr/local/nginx/conf/htpasswd;
		}

5. 继续在 zbx_nginx_stats.py 修改stat_url配置如下:

		stat_url = 'http://CenNGINX01_IPADDRESS/nginx_stat'
		
6. 继续修改 zbx_nginx_stats.py 需要注意这里的日志文件与NGINX的日志文件相对应。例如NGINX配置为"access_log  /var/log/nginx/host.access.log  main;" 则配置如下：

		nginx_log_file_path = '/var/log/nginx/host.access.log'

7. 继续修改 zbx_nginx_stats.py 的配置

		# Optional Basic Auth
		username = 'user'
		password = 'pass'

8. 继续配置临时文件，配置如下：

		seek_file = '/tmp/nginx_log_stat'
		
9. 授权文件

		chmod +x zbx_nginx_stats.py
		
10. Configure cron to run script every one minute:

		$sudo crontab -e
		
		*/1 * * * *  /usr/bin/python /usr/local/etc/zabbix_agentd.conf.d/zbx_nginx_stats.py
		
		service crond reload

11. Import zbx_nginx_template.xml into zabbix in Tepmplate section web gui.

12. 为主机关联模板


#### 如果在WebUI上面没有获取到最新值，可通过下面方式进行检测：

* zabbix_sender -z Zabbix_Server -s CenNGINX01 -k nginx[accepted_connections] -o 2
