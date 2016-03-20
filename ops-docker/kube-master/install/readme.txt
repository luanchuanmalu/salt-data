--------------------------ETCD install------------------------------------------------
1. install etcd by etcdinstall.sh
2. firewall setting
3. check the etcd default port setting, if not match, change and restart the service
--------------------------kubernetes Master install------------------------------------
1. copy all packages to /tmp/kubernetes folder from minion-packages\kubernetes\
2. copy the kubemasterinstall.sh to /tmp/kubernetes
3. on the server, cd to the folder /tmp/kubernetes, install by sh file kubemasterinstall.sh
--------------------------kubernetes Master setting------------------------------------
