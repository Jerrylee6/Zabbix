#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import urllib2, base64, re, struct, time, socket, sys, datetime

try:
    import json
except:
    import simplejson as json

zabbix_host = '192.168.84.242'  # Zabbix server IP
zabbix_port = 10051             # Zabbix server port
hostname = 'CenNGINX01'         # Name of monitored host, like it shows in zabbix web ui
time_delta = 1                  # grep interval in minutes

# URL to php-fpm stat (pm.status_path)
stat_url = 'http://192.168.84.108/phpfpm_status'

# Optional Basic Auth
username = 'user'
password = 'pass'


class Metric(object):
    def __init__(self, host, key, value, clock=None):
        self.host = host
        self.key = key
        self.value = value
        self.clock = clock

    def __repr__(self):
        if self.clock is None:
            return 'Metric(%r, %r, %r)' % (self.host, self.key, self.value)
        return 'Metric(%r, %r, %r, %r)' % (self.host, self.key, self.value, self.clock)


# If the ZABBIX Host is not native, then the zabbix_host value is updated
def send_to_zabbix(metrics, zabbix_host='127.0.0.1', zabbix_port=10051):
    j = json.dumps
    metrics_data = []
    for m in metrics:
        clock = m.clock or ('%d' % time.time())
        metrics_data.append(
            ('{"host":%s,"key":%s,"value":%s,"clock":%s}') % (j(m.host), j(m.key), j(m.value), j(clock)))
    json_data = ('{"request":"sender data","data":[%s]}') % (','.join(metrics_data))
    data_len = struct.pack('<Q', len(json_data))
    packet = 'ZBXD\x01' + data_len + json_data

    # print packet			#debuging print packet
    # print ':'.join(x.encode('hex') for x in packet)

    try:
        zabbix = socket.socket()
        zabbix.connect((zabbix_host, zabbix_port))
        zabbix.sendall(packet)
        resp_hdr = _recv_all(zabbix, 13)
        if not resp_hdr.startswith('ZBXD\x01') or len(resp_hdr) != 13:
            print 'Wrong zabbix response'
            return False
        resp_body_len = struct.unpack('<Q', resp_hdr[5:])[0]
        resp_body = zabbix.recv(resp_body_len)
        zabbix.close()

        resp = json.loads(resp_body)
        # print resp
        if resp.get('response') != 'success':
            print 'Got error from Zabbix: %s' % resp
            return False
        return True
    except:
        print 'Error while sending data to Zabbix'
        return False


def _recv_all(sock, count):
    buf = ''
    while len(buf) < count:
        chunk = sock.recv(count - len(buf))
        if not chunk:
            return buf
        buf += chunk
    return buf


def get(url, login, passwd):
    req = urllib2.Request(url)
    if login and passwd:
        base64string = base64.encodestring('%s:%s' % (login, passwd)).replace('\n', '')
        req.add_header("Authorization", "Basic %s" % base64string)
    q = urllib2.urlopen(req)
    res = q.read()
    q.close()
    return res


def parse_nginx_stat(data):
    a = {}
    # pool_name
    a['pool'] = re.match(r'(.*):\s+(\w*)', data[0], re.M | re.I).group(2)
    # process_manager
    a['process_manager'] = re.match(r'(.*):\s+(\w*)', data[1], re.M | re.I).group(2)
    # start_time
    a['start_time'] = re.match(r'(.*):\s+(.+)\s+\+\d+', data[2], re.M | re.I).group(2)
    # start_since
    a['start_since'] = re.match(r'(.*):\s+(\w*)', data[3], re.M | re.I).group(2)
    # accepted_conn
    a['accepted_conn'] = re.match(r'(.*):\s+(\w*)', data[4], re.M | re.I).group(2)
    # listen_queue
    a['listen_queue'] = re.match(r'(.*):\s+(\w*)', data[5], re.M | re.I).group(2)
    # max_listen_queue
    a['max_listen_queue'] = re.match(r'(.*):\s+(\w*)', data[6], re.M | re.I).group(2)
    # listen_queue_len
    a['listen_queue_len'] = re.match(r'(.*):\s+(\w*)', data[7], re.M | re.I).group(2)
    # idle_processes
    a['idle_processes'] = re.match(r'(.*):\s+(\w*)', data[8], re.M | re.I).group(2)
    # active_processes
    a['active_processes'] = re.match(r'(.*):\s+(\w*)', data[9], re.M | re.I).group(2)
    # total_processes
    a['total_processes'] = re.match(r'(.*):\s+(\w*)', data[10], re.M | re.I).group(2)
    # max_active_processes
    a['max_active_processes'] = re.match(r'(.*):\s+(\w*)', data[11], re.M | re.I).group(2)
    # max_children_reached
    a['max_children_reached'] = re.match(r'(.*):\s+(\w*)', data[12], re.M | re.I).group(2)
    # slow_requests
    a['slow_requests'] = re.match(r'(.*):\s+(\w*)', data[13], re.M | re.I).group(2)
    return a

# print '[12/Mar/2014:03:21:13 +0400]'

d = datetime.datetime.now() - datetime.timedelta(minutes=time_delta)
minute = int(time.mktime(d.timetuple()) / 60) * 60
d = d.strftime('%d/%b/%Y:%H:%M')


metric = (len(sys.argv) >= 2) and re.match(r'phpfpm\[(.*)\]', sys.argv[1], re.M | re.I).group(1) or False
data = get(stat_url, username, password).split('\n')
data = parse_nginx_stat(data)

data_to_send = []

# Adding the metrics to response
if not metric:
    for i in data:
        data_to_send.append(Metric(hostname, ('phpfpm[%s]' % i), data[i]))
else:
    print data[metric]


send_to_zabbix(data_to_send, zabbix_host, zabbix_port)
