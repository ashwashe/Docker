# 1.Oracle instant client intallation guide

FROM ubuntu:latest

MAINTAINER Ashwath Shetty "ashwath.shetty@capgemini.com"


RUN apt-get -y update && apt-get -y upgrade

#Install tomcat 8


RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN mkdir /usr/local/tomcat
RUN wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.35/* /usr/local/tomcat/
EXPOSE 8080

CMD /usr/local/tomcat/bin/catalina.sh run

RUN apt-get -y install vim
RUN apt-get -y install curl
RUN apt-get -y install libaio1
RUN apt-get -y install alien

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm  /usr/src/app
COPY oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm  /usr/src/app
COPY oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm  /usr/src/app


RUN alien -i oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
RUN alien -i  oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN alien -i  oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm


COPY oracle.conf /etc/ld.so.conf.d

COPY oracle.sh /etc/profile.d

RUN ln -s /usr/include/oracle/11.2/client /usr/lib/oracle/11.2/client64/include

RUN mkdir /usr/lib/oracle/11.2/client64/network

RUN mkdir /usr/lib/oracle/11.2/client64/network/admin

COPY sqlnet.ora /usr/lib/oracle/11.2/client64/network/admin

COPY tnsnames.ora /usr/lib/oracle/11.2/client64/network/admin

RUN chmod a+w /usr/lib/oracle/11.2/client64/network/admin/sqlnet.ora
RUN chmod a+w /usr/lib/oracle/11.2/client64/network/admin/tnsnames.ora

ENV ORACLE_HOME=/usr/lib/oracle/11.2/client64 
ENV LD_LIBRARY_PATH="$ORACLE_HOME"
ENV PATH="$ORACLE_HOME:$PATH"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib:$ORACLE_HOME


