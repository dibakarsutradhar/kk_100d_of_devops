There is a critical issue going on with the Nautilus application in Stratos DC. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server.



Look into the issue and fix the same.

```shell
2025-09-14 16:30:19 0 [ERROR] mariadbd: Can't create/write to file '/run/mariadb/mariadb.pid' (Errcode: 13 "Permission denied")
2025-09-14 16:30:19 0 [ERROR] Can't start server: can't create PID file: Permission denied
[peter@stdb01 lib]$ sudo mkdir -p /run/mariadb
[peter@stdb01 lib]$ sudo chown mysql:mysql /run/mariadb
[peter@stdb01 lib]$ sudo chmod 755 /run/mariadb
[peter@stdb01 lib]$ sudo systemctl start mariadb
[peter@stdb01 lib]$ sudo systemctl status mariadb -l
● mariadb.service - MariaDB 10.5 database server
```
