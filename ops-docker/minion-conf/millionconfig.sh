#！/bin/sh
writekubernetesconfig()
{
CONFFILE=$1
MASTERSERVER=$2
ETCDSERVER=$3
cat <<EOF> ${CONFFILE}
###
# kubernetes system config
#
# The following values are used to configure various aspects of all
# kubernetes services, including
#
#   kube-apiserver.service
#   kube-controller-manager.service
#   kube-scheduler.service
#   kubelet.service
#   kube-proxy.service
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow_privileged=false"

# How the controller-manager, scheduler, and proxy find the apiserver
KUBE_MASTER="--master=${MASTERSERVER}"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd_servers=${ETCDSERVER}"
EOF
}


writekubelete()
{
KBLETFILE=$1
HOSTNAME=$2
APISERVER=$3
cat <<EOF> ${KBLETFILE}
###
# kubernetes kubelet (minion) config

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname_override=${HOSTNAME}"

# location of the api-server
KUBELET_API_SERVER="--api_servers=${APISERVER}"

# Add your own!
KUBELET_ARGS=""
EOF
}

writeipconfig()
{
IPFILE=$1
KBRIP=$2
KBRMASK=$3
cat <<EOF> ${IPFILE}
DEVICE=kbr0
ONBOOT=yes
BOOTPROTO=static
IPADDR=$KBRIP
NETMASK=255.255.255.0
GATEWAY=$KBRMASK
TYPE=Bridge
USERCTL=no
IPV6INIT=no
EOF
}

writeobr0config()
{
BRFILE=$1
cat <<EOF> ${BRFILE}
DEVICE=obr0
ONBOOT=yes
DEVICETYPE=ovs
TYPE=OVSBridge
HOTPLUG=no
USERCTL=no
BRIDGE=kbr0
EOF
}


#get config and do the setting, openvswitch gre, route, ip, kubelete
CONFIGFILE='/srv/salt-data/minion-conf/minionlist.ini'
echo "Config setting by $CONFIGFILE"
profile=`sed -n '/minions/'p $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`
hostname=$(hostname)
for SECTION in $profile
do
	echo $SECTION $hostname
	if [[ "$SECTION" == "$hostname" ]]
		then
		kbrip=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbrip[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $kbrip
		kbrgetway=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbrgetway[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $kbrgetway
		kbripfile=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbripfile[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $kbripfile
		obripfile=$(sed '/^\['"$SECTION"'\]/,$!d;/^obripfile[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $obripfile
		kubeletconf=$(sed '/^\['"$SECTION"'\]/,$!d;/^kubeletconf[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $kubeletconf
		api_server=$(sed '/^\['"$SECTION"'\]/,$!d;/^api_server[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $api_server
		etcd_server=$(sed '/^\['"$SECTION"'\]/,$!d;/^etcd_server[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		#echo $etcd_server
		kubernetesconfig=$(sed '/^\['"$SECTION"'\]/,$!d;/^kubernetesconfig[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		routedev=$(sed '/^\['"$SECTION"'\]/,$!d;/^routedev[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		routefile=$(sed '/^\['"$SECTION"'\]/,$!d;/^routefile[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFIGFILE)
		# set ip to the file
		echo "set the ip file $kbripfile for $SECTION"
		writeipconfig $kbripfile $kbrip $kbrgetway
		echo "set obr0 config file for $SECTION"
		writeobr0config $obripfile
		echo "output the route for $SECTION to file $routefile"
		echo "$kbrgetway/16 via 0.0.0.0 dev $routedev">$routefile
		# set kubelete
		echo "set kubelet file $kubeletconf for $SECTION"
		writekubelete $kubeletconf $hostname $api_server
		# set kubernetes config etcd_server kubernetesconfig
		echo "set kubernetes config file $kubernetesconfig for $SECTION"
		writekubernetesconfig $kubernetesconfig  $api_server $etcd_server
		#break
	fi
done
echo "Config setting done"
