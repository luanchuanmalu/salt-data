echo "start gresetting"
ovs-vsctl add-port obr0 minion1 -- set Interface minion1 type=gre options:remote_ip=192.168.93.139
ovs-vsctl add-port obr0 minion2 -- set Interface minion2 type=gre options:remote_ip=192.168.93.140
ovs-vsctl add-port obr0 minion5 -- set Interface minion5 type=gre options:remote_ip=192.168.93.145
ovs-vsctl add-port obr0 minion6 -- set Interface minion6 type=gre options:remote_ip=192.168.93.147
ovs-vsctl add-port obr0 minion7 -- set Interface minion7 type=gre options:remote_ip=192.168.93.148
ovs-vsctl add-port obr0 minion8 -- set Interface minion8 type=gre options:remote_ip=192.168.93.130
ovs-vsctl add-port obr0 minion9 -- set Interface minion9 type=gre options:remote_ip=192.168.93.149
echo "end gresetting"
