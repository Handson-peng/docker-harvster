FROM alpine

RUN apk update
RUN apk add --no-cache python3 python3-dev git build-base libffi-dev openssl-dev procps
RUN apk add --no-cache mariadb mariadb-client
RUN mysql_install_db --ldata=/var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql
COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install pip --upgrade
RUN pip3 install git+git://github.com/HSF/harvester.git
RUN pip3 install kubernetes uwsgi
RUN pip3 install mysql-connector
RUN mkdir /var/log/panda
COPY CERN-bundle.pem /etc/pki/tls/certs/CERN-bundle.pem

WORKDIR /usr
COPY panda_harvester etc/sysconfig/panda_harvester
COPY panda_harvester-uwsgi.ini etc/panda/panda_harvester-uwsgi.ini
COPY panda_harvester-uwsgi etc/rc.d/init.d/panda_harvester-uwsgi

RUN mv etc/panda/panda_common.cfg.rpmnew etc/panda/panda_common.cfg
RUN ln -s /mnt/panda_harvester.cfg /usr/etc/panda/panda_harvester.cfg
RUN ln -s /mnt/panda_queueconfig /usr/etc/panda/panda_queueconfig


COPY harvester_start.sh /usr/harvester_start.sh
CMD sh harvester_start.sh
