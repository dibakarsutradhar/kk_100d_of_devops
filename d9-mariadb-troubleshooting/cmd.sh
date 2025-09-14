## check permissions
ls -ld /var/lib/mysql
ls -l /var/lib/mysql
## it should be owned by `mysql:mysql`

## verify config syntax (check if any unknown/invalid options exist)
my_print_defaults mysqld

## check port usage (make sure nothing is using MariaDB's port)
ss -lntp | grep 3306

## try manual start for debug
sudo -u mysql /usr/libexec/mariadbd --basedir=/usr --verbose --skip-grant-tables

## or run 
journalctl -xeu mariadb.service | tail -n 50

## Can't create test file '/var/lib/mysql/stdb01.lower-test' (Errcode: 13 "Permission denied")
## This means MariaDB cannot write to /var/lib/mysql because of wrong permissions/ownership.

## correct ownership
sudo chown -R mysql:mysql /var/lib/mysql

## make sure permissions are restrictive enough
sudo chmod 750 /var/lib/mysql

## verify (should now show `drwxr-x--- 2 mysql mysql ...`)
ls -ld /var/lib/mysql

## restart MariaDb
sudo systemctl start mariadb
sudo systemctl status mariadb -l

## 2025-09-14 16:30:19 0 [ERROR] Can't start server: can't create PID file: Permission denied
## MariaDB is failing because it cannot write the PID file here: `/run/mariadb/mariadb.pid`

## set proper ownership 
sudo chown mysql:mysql /run/mariadb

## restrict permissions
sudo chmod 755 /run/mariadb

## restart MariaDB
sudo systemctl start mariadb
sudo systemctl status mariadb -l

