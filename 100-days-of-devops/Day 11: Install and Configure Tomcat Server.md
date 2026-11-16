# Day 11

The Nautilus application development team recently finished the beta version of one of their Java-based applications, which they are planning to deploy on one of the app servers in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server. Based on the requirements mentioned below complete the task:



a. Install tomcat server on App Server 1.

b. Configure it to run on port 8084.

c. There is a ROOT.war file on Jump host at location /tmp.


Deploy it on this tomcat server and make sure the webpage works directly on base URL i.e curl http://stapp01:8084

on app server 1
cat /etc/os-release
// centos
sudo yum install -y tomcat

sudo vi /usr/share/tomcat/conf/server.xml

<Connector executor="tomcatThreadPool"
               port="8080" protocol="HTTP/1.1" // change it  to port 8084
               connectionTimeout="20000"
               redirectPort="8443"
               maxParameterCount="1000"
               />

sudo systemctl start tomcat.service
sudo systemctl status tomcat.service

sudo ls /usr/share/tomcat/webapps/


on jump server
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-copy-id tony@stapp01

scp /tmp/ROOT.war tony@stapp01:/tmp

on app server 1
ls -l /tmp/
sudo chown tomcat:tomcat /tmp/ROOT.war 
sudo mv /tmp/ROOT.war /usr/share/tomcat/webapps/
[tony@stapp01 ~]$ ls -l /usr/share/tomcat/webapps/
total 12
drwxr-xr-x 4 tomcat tomcat 4096 Nov  4 15:31 ROOT
-rw-r--r-- 1 tomcat tomcat 4529 Nov  4 15:28 ROOT.war


sudo systemctl stop tomcat
sudo rm -rf /usr/share/tomcat/webapps/ROOT
sudo systemctl start tomcat
sudo systemctl status tomcat
curl http://stapp01:8084