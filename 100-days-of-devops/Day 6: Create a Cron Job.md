The Nautilus system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in Stratos DC on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:



a. Install cronie package on all Nautilus app servers and start crond service. 



b. Add a cron */5 * * * * echo hello > /tmp/cron_text for root user.|

note: there is 3 servers(stapp01, stapp02, stapp03)

ssh user@server

cat /etc/os-release
sudo yum install -y cronie

sudo vim /etc/crontab
cat /etc/crontab


SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
*/5 * * * * root echo hello > /tmp/cron_text

sudo systemctl start crond.service
sudo systemctl status crond.service

