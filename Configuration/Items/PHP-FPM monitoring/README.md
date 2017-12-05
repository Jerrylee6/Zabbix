Linux Server PHP-FPM Monitor
===

说明
----
请根据Linux系统针对PHP-FPM性能进行监控,环境需求："python","htpasswd","NGINX","PHP-FPM"

> **PHP-FPM KEY的取值详解:**

1. pool_name                        表示：PHP-FPM pool名称,默认为"www"
2. process_manager                  表示：PHP-FPM 进程的管理方式"dynamic"
3. start_time                       表示：PHP-FPM服务启动日期,reload后时间将会更新
4. start_since                      表示：PHP-FPM运行的时长,获取时间戳
5. accepted_conn                    表示: PHP-FPM接受的请求数
6. accepted_conn\min                表示：PHP-FPM平均1分钟接收的请求数
7. listen_queue                     表示: PHP-FPM请求等待队列,若该值不为0,需要增加FPM的进程数量
8. max_listen_queue                 表示：PHP-FPM请求等待队列最高的数量
9. listen_queue_len                 表示：socket等待队列长度
10. idle_processes                  表示：PHP-FPM空闲进程数量
11. active_processes                表示：PHP-FPM活跃进程数量
12. total_processes                 表示：PHP-FPM总进程数量
13. max_active_processes            表示：PHP-FPM最大的活跃进程数量
14. max_children_reached            表示：PHP-FPM进程最大数量限制的次数,若数量不为0则表示最大进程数量设置太小,需优化
15. slow_requests                   表示：启用PHP-FPM缓慢请求数量


### 部署步骤
----

1. 安装环境需求

		yum install python htpasswd
		htpasswd -c /usr/local/nginx/conf/htpasswd user		# 暂时不支持HTTPS访问phpfpm_status
		New password: pass									# 暂时不支持HTTPS访问phpfpm_status
		Re-type new password: pass							# 暂时不支持HTTPS访问phpfpm_status

2. 将"zbx_phpfpm_stats.py" 脚本拷贝到"/usr/local/etc/zabbix_agentd.conf.d/" 目录下

3. 修改"zbx_phpfpm_stats.py" 内容

		zabbix_host = '192.168.84.242'   		# Zabbix server IP
		zabbix_port = 10051                     # Zabbix server port
		hostname = 'CenNGINX01'   	            # Name of monitored host, like it shows in zabbix web ui
		time_delta = 1                          # grep interval in minutes

4. 开启PHP-FPM status状态,并重新加载配置文件

		vim /usr/local/etc/php-fpm.conf
		pm.status_path = /phpfpm_status
		
5. 开启NGINX的StubStatus模块的配置,并重新加载配置文件

		# StubStatus on Zabbix Monitor
		location /phpfpm_status {
			fastcgi_pass 127.0.0.1:9000;		#PHP-FPM连接
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
		}

6. 继续在 zbx_phpfpm_stats.py 修改stat_url配置如下:

		stat_url = 'http://CenNGINX01_IPADDRESS/phpfpm_status'

7. 继续修改 zbx_phpfpm_stats.py 的配置

		# Optional Basic Auth
		username = 'user'
		password = 'pass'
		
8. 授权文件

		chmod +x zbx_phpfpm_stats.py
		
9. Configure cron to run script every one minute:

		$sudo crontab -e
		
		*/1 * * * *  /usr/bin/python /usr/local/etc/zabbix_agentd.conf.d/zbx_phpfpm_stats.py
		
		service crond reload

10. Import zbx_phpfpm_template.xml into zabbix in Tepmplate section web gui.

11. 为主机关联模板


#### 如果在WebUI上面没有获取到最新值，可通过下面方式进行检测：

* zabbix_sender -z Zabbix_Server -s CenNGINX01 -k phpfpm[accepted_conn] -o 2
