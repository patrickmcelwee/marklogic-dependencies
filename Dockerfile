FROM centos:centos6.6
MAINTAINER Patrick McElwee <patrick.mcelwee@marklogic.com>

RUN yum -y install glibc.i686 gdb.x86_64 redhat-lsb.x86_64

ENV MARKLOGIC_INSTALL_DIR /opt/MarkLogic
ENV MARKLOGIC_DATA_DIR /data

ENV MARKLOGIC_FSTYPE ext4
ENV MARKLOGIC_USER daemon
ENV MARKLOGIC_PID_FILE /var/run/MarkLogic.pid
ENV MARKLOGIC_MLCMD_PID_FILE /var/run/mlcmd.pid
ENV MARKLOGIC_UMASK 022

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/MarkLogic/mlcmd/bin

EXPOSE 7997 7998 7999 8000 8001 8002
