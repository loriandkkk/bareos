FROM centos:7

RUN \
  yum-config-manager -y \
    --add-repo http://download.bareos.org/bareos/release/17.2/CentOS_7/bareos.repo \
    --add-repo http://download.bareos.org/bareos/contrib/CentOS_7/bareos:contrib.repo && \
  yum-config-manager --enable \
    bareos \
    bareos:contrib && \
  yum update -y

# Install MySQL, VMware plugin
RUN \
  yum install -y \
    epel-release \
    python-pyvmomi python-requests python-six \
    e2fsprogs libuuid-devel openssl-devel perl-devel perl-Crypt-SSLeay \
    perl-XML-LibXML libncurses.so.5 perl-Crypt-SSLeay && \
  yum install -y \
    bareos-filedaemon \
    bareos-filedaemon-python-plugin \
    bareos-contrib-filedaemon-python-plugin-mysql \
    mysql \
    bareos-vmware-plugin \
  yum clean all

COPY VMware-vSphere-CLI-6.5.0-4566394.x86_64.tar.gz /root/vcli.tar.gz
COPY VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle /tmp/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN \
  chmod u+x /tmp/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle && \
  /tmp/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle --console --required --eulas-agreed && \
  cd /root && tar xvf vcli.tar.gz && \
  yes | PAGER=cat /root/vmware-vsphere-cli-distrib/vmware-install.pl default && \
  chmod u+x /docker-entrypoint.sh

VOLUME [ "/etc/bareos/bareos-fd.d" ]
EXPOSE 9102

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/bareos-fd", "-u", "bareos", "-f"]
