#!/bin/sh
source /usr/etc/sysconfig/panda_harvester
DB_USER=`python -c 'from pandaharvester.harvesterconfig import harvester_config;print(harvester_config.db.user)'`
DB_PASSWORD=`python -c 'from pandaharvester.harvesterconfig import harvester_config;print(harvester_config.db.password)'`
DB_SCHEMA=`python -c 'from pandaharvester.harvesterconfig import harvester_config;print(harvester_config.db.schema)'`
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' --port=3306 --nowatch
for i in `seq 1 30`
do
    if [ -f /var/lib/mysql/`hostname`.pid ]; then
        mysql -e "create database ${DB_SCHEMA};" && \
        mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'" && \
        mysql -e "GRANT ALL PRIVILEGES ON ${DB_SCHEMA}.* TO '${DB_USER}'@'localhost';"
        break
    else
        sleep 2
        continue
    fi
done
/usr/etc/rc.d/init.d/panda_harvester-uwsgi start
/bin/sh
