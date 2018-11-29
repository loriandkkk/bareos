FROM centos:7

RUN \
  yum-config-manager -y \
    --add-repo http://download.bareos.org/bareos/release/17.2/CentOS_7/bareos.repo \
    --add-repo http://download.bareos.org/bareos/contrib/CentOS_7/bareos:contrib.repo && \
  yum-config-manager --enable \
    bareos \
    bareos:contrib && \
  yum update -y && \
  yum install -y \
    bareos-filedaemon \
    bareos-filedaemon-python-plugin \
    bareos-contrib-filedaemon-python-plugin-mysql \
    mysql && \
  yum clean all

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

VOLUME [ "/etc/bareos/bareos-fd.d" ]
EXPOSE 9102

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/bareos-fd", "-u", "bareos", "-f"]
