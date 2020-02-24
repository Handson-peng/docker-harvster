#!/bin/sh
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' --port=3306 --nowatch
sleep 3
mysql -e "create database harvester;" && \
mysql -e "CREATE USER 'harvester'@'localhost' IDENTIFIED BY 'PASSWORD'" && \
mysql -e "GRANT ALL PRIVILEGES ON harvester.* TO 'harvester'@'localhost';"
/usr/etc/rc.d/init.d/panda_harvester-uwsgi start
