# TO DO

Following a security audit, the xFusionCorp Industries security team has opted to enhance application and server security with SELinux. To initiate testing, the following requirements have been established for App server 3 in the Stratos Datacenter:



Install the required SELinux packages.

Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.

No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.

Disregard the current status of SELinux via the command line; the final status after the reboot should be disabled.



 cat /etc/os-release



 https://wiki.centos.org/HowTos(2f)SELinux.html

 sudo yum update

 https://www.akamai.com/cloud/guides/a-beginners-guide-to-selinux-on-centos-7

 sudo yum install -y selinux-policy
 sudo vim /etc/selinux/config