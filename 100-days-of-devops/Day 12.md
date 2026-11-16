# Day 12

Our monitoring tool has reported an issue in Stratos Datacenter. One of our app servers has an issue, as its Apache service is not reachable on port 8088 (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.



Use tools like telnet, netstat, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.

Once fixed, you can test the same using command curl http://stapp02:8088 command from jump host.

Note: Please do not try to alter the existing index.html code, as it will lead to task failure.


sudo yum install net-tools -y

netstat -tulnp | grep :8088

curl http://stapp01:8088
curl: (7) Failed to connect to stapp01 port 8088: Connection refused

[tony@stapp01 ~]$ netstat -tulnp | grep :8088
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 127.0.0.1:8088          0.0.0.0:*               LISTEN      -  


find config file of apache
httpd -V | grep -E 'HTTPD_ROOT|SERVER_CONFIG_FILE'
 -D HTTPD_ROOT="/etc/httpd"
 -D SERVER_CONFIG_FILE="conf/httpd.conf"


cat /etc/httpd/conf/httpd.conf

sudo ss -tulpn | grep :8088
 sudo systemctl stop sendmail

 - 'Apache' is not reachable on port '8088' on App server 1

 cat /etc/httpd/conf/httpd.conf | grep Listen


 sudo firewall-cmd --permanent --zone=public --add-port=8088/tcp
 but the firewall cmd does not exist

 sudo iptables -L INPUT -n -v --line-numbers
[sudo] password for tony: 
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1     1336 3154K ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
2        0     0 ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0           
3        1    60 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           
4        2   120 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            state NEW tcp dpt:22
5        3   180 REJECT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Insert an explicit rule at the top of the INPUT chain to allow TCP traffic on port 8088:
sudo iptables -I INPUT 1 -p tcp --dport 8088 -j ACCEPT