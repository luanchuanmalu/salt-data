1. 初始化hostname, hosts
2. 执行centos7init.sh安装salt-minion
3. 安装模板生成一个新的minion配置，只需要改id:，替换/etc/salt/minion
4. 把salt-minion加入自动启动chkconfig salt-minion on; systemctl enable salt-minion;
5. 重启 systemctl restart salt-minion, 服务端即可收到请求