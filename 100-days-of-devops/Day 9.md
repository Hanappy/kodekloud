# Day 9


ps aux | grep -i mariadb
[peter@stdb01 ~]$ sudo systemctl start mariadb.service
Job for mariadb.service failed because the control process exited with error code.
See "systemctl status mariadb.service" and "journalctl -xeu mariadb.service" for details.
[peter@stdb01 ~]$ journalctl -xeu mariadb.service


[peter@stdb01 ~]$ sudo chown -R mysql:mysql /var/lib/mysql
[peter@stdb01 ~]$ sudo chmod 755 /var/lib/mysql
[peter@stdb01 ~]$ sudo systemctl start mariadb
[peter@stdb01 ~]$ sudo systemctl status mariadb.service