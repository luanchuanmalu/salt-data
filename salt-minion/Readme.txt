1. hostname selinux  /etc/selinux/config  disabled - restart
2. salt-minion �� 
	rpm -ivh http://mirrors.sohu.com/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
	yum -y install salt-minion
   	���������yum clean all��yum clean packages
3. ��װģ������һ���µ�minion���ã�ֻ��Ҫ��id:���滻/etc/salt/minion
4. ��salt-minion�����Զ�����systemctl enable salt-minion;
5. ���� systemctl restart salt-minion, ����˼����յ�����
