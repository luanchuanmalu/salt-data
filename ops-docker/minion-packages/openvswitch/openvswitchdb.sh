echo "start openvswitchdb"
setenforce 0
semanage fcontext -a -t openvswitch_rw_t "/etc/openvswitch(/.*)?"
restorecon -Rv /etc/openvswitch
echo "end openvswitchdb"
