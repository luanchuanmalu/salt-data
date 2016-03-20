1. hostname selinux  /etc/selinux/config  disabled - restart
2. salt-minion ： 
	rpm -ivh http://mirrors.sohu.com/fedora-epel/7/x86_64/e/epel-release-7-2.noarch.rpm
	yum -y install salt-minion
   	如果有问题yum clean all，yum clean packages
3. 安装模板生成一个新的minion配置，只需要改id:，替换/etc/salt/minion
4. 把salt-minion加入自动启动systemctl enable salt-minion;
5. 重启 systemctl restart salt-minion, 服务端即可收到请求
