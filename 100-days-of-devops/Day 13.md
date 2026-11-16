We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now Apache’s port i.e 8089 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:



1. Install iptables and all its dependencies (including iptables-services) on each app server (stapp01, stapp02 and stapp03). iptables-services alone does not provide the iptables command, so install both packages before you enable the service.


2. Block incoming port 8089 on all app servers for everyone except the LBR (load balancer) host stlb01. Either DROP or REJECT is fine.


3. Make sure the rules remain, even after system reboot: save them to /etc/sysconfig/iptables and enable the iptables service. Do not reboot the servers; the check reads the saved rules and the service state.


sudo yum install iptables -y

sudo iptables -I INPUT 1 -p tcp -s stlb01 --dport 8089 -j ACCEPT
sudo iptables-save | sudo tee /etc/sysconfig/iptables

sudo iptables -A INPUT -p tcp --dport 8089 -j DROP
sudo iptables-save | sudo tee /etc/sysconfig/iptables


---

sudo yum install iptables-services -y

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
Last metadata expiration check: 1:18:16 ago on Wed Nov 11 09:49:24 2026.
Package iptables-services-1.8.10-11.1.el9.noarch is already installed.
Dependencies resolved.
Nothing to do.
Complete!

sudo yum install iptables -y
Last metadata expiration check: 1:18:40 ago on Wed Nov 11 09:49:24 2026.
Dependencies resolved.
===========================================================================================
 Package                      Architecture   Version                    Repository    Size
===========================================================================================
Installing:
 iptables-legacy              x86_64         1.8.10-11.1.el9            epel          50 k
Installing dependencies:
 iptables-legacy-libs         x86_64         1.8.10-11.1.el9            epel          38 k

Transaction Summary
===========================================================================================
Install  2 Packages

Total download size: 88 k
Installed size: 184 k
Downloading Packages:
(1/2): iptables-legacy-1.8.10-11.1.el9.x86_64.rpm          3.9 MB/s |  50 kB     00:00    
(2/2): iptables-legacy-libs-1.8.10-11.1.el9.x86_64.rpm     1.9 MB/s |  38 kB     00:00    
-------------------------------------------------------------------------------------------
Total                                                      584 kB/s |  88 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                   1/1 
  Installing       : iptables-legacy-libs-1.8.10-11.1.el9.x86_64                       1/2 
  Installing       : iptables-legacy-1.8.10-11.1.el9.x86_64                            2/2 
  Running scriptlet: iptables-legacy-1.8.10-11.1.el9.x86_64                            2/2 
  Verifying        : iptables-legacy-1.8.10-11.1.el9.x86_64                            1/2 
  Verifying        : iptables-legacy-libs-1.8.10-11.1.el9.x86_64                       2/2 

Installed:
  iptables-legacy-1.8.10-11.1.el9.x86_64    iptables-legacy-libs-1.8.10-11.1.el9.x86_64   

Complete!

[banner@stapp03 ~]$ sudo cat /etc/sysconfig/iptables
# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT



sudo iptables -A INPUT -p tcp --dport 8089 -j DROP
sudo iptables-save | sudo tee /etc/sysconfig/iptables

[banner@stapp03 ~]$ sudo cat /etc/sysconfig/iptables
# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
[banner@stapp03 ~]$ sudo iptables-save | sudo tee /etc/sysconfig/iptables
# Generated by iptables-save v1.8.10 on Wed Nov 11 11:15:55 2026
*filter
:INPUT ACCEPT [27:1992]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [16:2816]
-A INPUT -p tcp -m tcp --dport 8089 -j DROP
COMMIT
# Completed on Wed Nov 11 11:15:55 2026
[banner@stapp03 ~]$ sudo cat /etc/sysconfig/iptables
# Generated by iptables-save v1.8.10 on Wed Nov 11 11:15:55 2026
*filter
:INPUT ACCEPT [27:1992]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [16:2816]
-A INPUT -p tcp -m tcp --dport 8089 -j DROP
COMMIT
# Completed on Wed Nov 11 11:15:55 2026



[banner@stapp03 ~]$ sudo systemctl start iptables
[banner@stapp03 ~]$ sudo systemctl status iptables
● iptables.service - IPv4 firewall with iptables
     Loaded: loaded (/usr/lib/systemd/system/iptables.service; disabled; preset: disabled)
     Active: active (exited) since Wed 2026-11-11 11:16:40 UTC; 2s ago
    Process: 54546 ExecStart=/usr/libexec/iptables/iptables.init start (code=exited, statu>
   Main PID: 54546 (code=exited, status=0/SUCCESS)
        CPU: 16ms

Nov 11 11:16:40 stapp03 systemd[1]: Starting IPv4 firewall with iptables...
Nov 11 11:16:40 stapp03 iptables.init[54546]: iptables: Applying firewall rules: [  OK  ]
Nov 11 11:16:40 stapp03 systemd[1]: Finished IPv4 firewall with iptables.
lines 1-10/10 (END)


- Apache on App Server 1, 2, 3 is not reachable on port 8089 from the LBR host stlb01: accept stlb01 before the DROP/REJECT rule, and make sure httpd is running

- The rules saved in /etc/sysconfig/iptables on App Server 1 do not allow port 8089 from the LBR host stlb01 (10.244.49.89): save the running rules with 'sudo service iptables save' or 'sudo iptables-save | sudo tee /etc/sysconfig/iptables'


View the live rules currently in memory:
sudo iptables -L -n -v

sudo iptables -I INPUT 1 -p tcp -s stlb01 --dport 8089 -j ACCEPT
sudo iptables-save | sudo tee /etc/sysconfig/iptables


iptables rule order:
sudo iptables -L INPUT -v -n --line-numbers


Apache configuration for port 8089:Check /etc/httpd/conf/httpd.conf to make sure Apache is configured to listen on port 8089:
grep -i "^Listen" /etc/httpd/conf/httpd.conf

sudo systemctl restart httpd
sudo systemctl enable httpd
sudo systemctl status httpd

curl -I http://stapp01:8089



if can't resolve dns stlb01

Search with grep (Simplest):
grep -w "stlb01" /etc/hosts

Extract just the IP address using awk:
grep -w "stlb01" /etc/hosts | awk '{print $1}'