1. ��ʼ��hostname
2. ִ��centos7init.sh��װsalt-minion �� yum -y install salt-minion
   ���������yum clean all��yum clean packages
3. ��װģ������һ���µ�minion���ã�ֻ��Ҫ��id:���滻/etc/salt/minion
4. ��salt-minion�����Զ�����systemctl enable salt-minion; chkconfig --add salt-minion
5. ���� systemctl restart salt-minion, ����˼����յ�����