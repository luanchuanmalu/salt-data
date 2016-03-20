#rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum -y install salt-master

cp master /etc/salt/master

systemctl restart salt-master
systemctl enable salt-master
systemctl status salt-master
