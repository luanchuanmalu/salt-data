echo "start exist-add-minion8"
echo "add obr0 and add gre"
ovs-vsctl add-port obr0 minion9 -- set Interface minion9 type=gre options:remote_ip=192.168.93.149
echo "add route rule"
ip route add 172.17.9.0/24 via 192.168.93.149 dev eno16777736
echo "172.17.9.0/24 via 192.168.93.149 dev eno16777736" >> /etc/sysconfig/network-scripts/route-eno16777736
echo "End exist-add-minion9"
