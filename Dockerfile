FROM alpine

RUN apk update
RUN apk add --no-cache python3 python3-dev git build-base libffi-dev openssl-dev procps
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install pip --upgrade
RUN pip3 install git+git://github.com/PanDAWMS/panda-harvester.git && \
RUN pip3 install git+git://github.com/HSF/harvester.git
RUN pip3 install kubernetes uwsgi 
RUN mkdir /var/log/panda
 
RUN apk update
RUN apk add --no-cache mariadb mariadb-client  
RUN mysql_install_db --ldata=/var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
RUN mysqld_safe --datadir='/var/lib/mysql' --port=3306 &
RUN pip3 install mysql-connector

RUN mysql -e "create database harvester;"
RUN mysql -e "CREATE USER 'harvester'@'localhost' IDENTIFIED BY 'PASSWORD'"
RUN mysql -e "GRANT ALL PRIVILEGES ON harvester.* TO 'harvester'@'localhost';"

WORKDIR /usr
COPY panda_harvester etc/sysconfig/panda_harvester
COPY panda_common.cfg etc/panda/panda_common.cfg
COPY panda_harvester.cfg etc/panda/panda_harvester.cfg
COPY panda_queueconfig.json etc/panda/panda_queueconfig.json
COPY ca-bundle.pem /opt/ca-bundle.pem
