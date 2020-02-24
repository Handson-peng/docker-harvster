FROM alpine

RUN apk update
RUN apk add --no-cache python3 python3-dev git build-base libffi-dev openssl-dev procps
RUN apk add --no-cache mariadb mariadb-client  
RUN mysql_install_db --ldata=/var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install pip --upgrade
RUN pip3 install git+git://github.com/HSF/harvester.git
RUN pip3 install kubernetes uwsgi 
RUN pip3 install mysql-connector
RUN mkdir /var/log/panda 

WORKDIR /usr
COPY panda_harvester etc/sysconfig/panda_harvester
COPY panda_common.cfg etc/panda/panda_common.cfg
COPY panda_harvester.cfg etc/panda/panda_harvester.cfg
COPY panda_queueconfig.json etc/panda/panda_queueconfig.json
COPY ca-bundle.pem /opt/ca-bundle.pem

RUN mv etc/rc.d/init.d/panda_harvester-uwsgi.rpmnew.template etc/rc.d/init.d/panda_harvester-uwsgi
RUN sed -i 's/userName="#FIXME"/userName="root"/g' etc/rc.d/init.d/panda_harvester-uwsgi
RUN sed -i 's/groupName="#FIXME"/groupName="#root"/g' etc/rc.d/init.d/panda_harvester-uwsgi
RUN sed -i 's/VIRTUAL_ENV=\/#FIXME/VIRTUAL_ENV=\/usr/g' etc/rc.d/init.d/panda_harvester-uwsgi
RUN sed -i 's/LOG_DIR=\/#FIXME/LOG_DIR=\/var/log/panda/g' etc/rc.d/init.d/panda_harvester-uwsgi

COPY harvester_start.sh /usr/harvester_start.sh
CMD sh harvester_start.sh
