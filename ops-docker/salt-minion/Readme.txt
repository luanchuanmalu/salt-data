here show you how to install salt-minion on the minions server.

1. hostname /etc/hostname selinux  /etc/selinux/config  disabled - restart,
2. salt-minion
	rpm -ivh http://mirrors.sohu.com/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
	yum -y install salt-minion
   	yum clean all yum clean packages
3. /etc/salt/minion
4. systemctl enable salt-minion
5. systemctl restart salt-minion

---------------------------------------------------------------------------
after salt-master accept the minion(salt-key -L, salt-key -A)
1. salt-call state.sls minion-packages
2. salt-call state.sls minion-conf
2. salt-call state.highstate
# docker exec -it 6a8bf299db70 /bin/sh
#  salt 'centos7minion*' cmd.run 'ps -ef | grep docker'
# salt 'centos7minion*' cmd.run 'systemctl restart docker'
