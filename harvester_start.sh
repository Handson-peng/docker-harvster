#!/bin/sh
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' --port=3306 --nowatch
for i in {1..10}
do
    if [ -f /var/lib/mysql/`hostname`.pid ]; then
        mysql -e "create database harvester;" && \
        mysql -e "CREATE USER 'harvester'@'localhost' IDENTIFIED BY 'PASSWORD'" && \
        mysql -e "GRANT ALL PRIVILEGES ON harvester.* TO 'harvester'@'localhost';"
        break
    else
        sleep 1
        continue
    fi
done
/usr/etc/rc.d/init.d/panda_harvester-uwsgi start
/bin/sh
