echo "start openvswitchbridge"
echo "add obr0 and add gre"
ovs-vsctl add-br obr0
echo "add linux bridge kbr0 and link obr0"
brctl addbr kbr0
brctl addif kbr0 obr0
echo "remove docker0 bridge"
ip link set dev docker0 down
ip link del dev docker0
echo "end openvswitchdb"
