echo "start routesetting"
echo "add route rule"
ip route add 172.17.1.0/24 via 192.168.93.139 dev eno16777736
ip route add 172.17.2.0/24 via 192.168.93.140 dev eno16777736
ip route add 172.17.5.0/24 via 192.168.93.145 dev eno16777736
ip route add 172.17.7.0/24 via 192.168.93.148 dev eno16777736
echo "end routesetting"
