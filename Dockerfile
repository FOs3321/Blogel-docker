FROM ubuntu:20.04

ADD hadoop-1.2.1.tar.gz /tmp

COPY ./blogel ./blogel

RUN set -x \
    && apt update \
    && apt upgrade -y\
    && apt install openssh-server -y\
    && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys \
    && apt install openjdk-8-jdk -y \
    && apt install mpich -y \
    && mv /tmp/hadoop-1.2.1 /usr/local 

EXPOSE 22
EXPOSE 54310

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/amd64/server
ENV HADOOP_HOME /usr/local/hadoop-1.2.1
ENV PATH $PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HADOOP_HOME/c++/Linux-amd64-64/lib

COPY ./core-site.xml $HADOOP_HOME/conf
COPY ./hdfs-site.xml $HADOOP_HOME/conf
COPY ./mapred-site.xml $HADOOP_HOME/conf
COPY ./setup.sh  $HADOOP_HOME/bin

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> $HADOOP_HOME/conf/hadoop-env.sh \
    && echo "/etc/init.d/ssh start" >> ~/.bashrc
