#！/bin/sh
getconfig2setting()
{
	SECTION=$1
	CONFILE=$2
  hostname=$(hostname)
  if [[ "$SECTION" != *end* ]]
		then
		remoteip=$(sed '/^\['"$SECTION"'\]/,$!d;/^remoteip[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		kbrip=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbrip[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		kbrgetway=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbrgetway[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		kbripfile=$(sed '/^\['"$SECTION"'\]/,$!d;/^kbripfile[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		routefile=$(sed '/^\['"$SECTION"'\]/,$!d;/^routefile[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		routedev=$(sed '/^\['"$SECTION"'\]/,$!d;/^routedev[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		kubeletconf=$(sed '/^\['"$SECTION"'\]/,$!d;/^kubeletconf[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		api_server=$(sed '/^\['"$SECTION"'\]/,$!d;/^api_server[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		etcd_server=$(sed '/^\['"$SECTION"'\]/,$!d;/^etcd_server[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
		kubernetesconfig=$(sed '/^\['"$SECTION"'\]/,$!d;/^kubernetesconfig[ \t]*=[ \t]*"*/!d;s///;s/"*[ \t]*$//;q' $CONFILE)
    #echo "$remoteip $kbrip $kbrgetway $kbripfile $routefile $routedev $kubeletconf $api_server $etcd_server $kubernetesconfig"
		if [[ "$SECTION" != "$hostname" ]]
			then
			#gre bridge part
			echo "set remote gre route to $SECTION for $hostname"
			resultgre=$(ovs-vsctl show | grep $remoteip)
			if [[ "$resultgre" != *options* ]]
				then
				echo "add the gre port for $SECTION"
	      ovs-vsctl add-port obr0 $SECTION -- set Interface $SECTION type=gre options:remote_ip=$remoteip
			else
				echo "already exist the gre port $resultgre";
			fi
			#route part
			resultroute=$(ip route | grep $remoteip)
			if [[ "$resultroute" != *via* ]]
				then
				echo "add the route for $SECTION"
				ip route add $kbrgetway/24 via $remoteip dev eno16777736
			else
				echo "already exist the route $resultroute";
			fi
			# route file
			if [ -f "$routefile" ]
				then
				touch $routefile
			fi
			resultroutefile=$(cat $routefile)
			if [[ "$resultroutefile" != *$remoteip* ]]
				then
				echo "output the route for $SECTION to file $routefile"
				echo "$kbrgetway/24 via $remoteip dev $routedev">>$routefile
			else
				echo "$routefile already exist the route $remoteip";
			fi
		else
			echo "set local ip kubelete and config for $hostname"
			#set ip
			resultip=$(ip addr | grep kbr0)
			if [[ "$resultip" != *$kbrip*brd* ]]
				then
				echo "set the ip for $SECTION"
				ip address add $kbrip/24 brd + dev kbr0
			else
				echo "$SECTION already have the ip $kbrip";
			fi
		fi
	else
		echo "The end"
  fi
}

writekubernetesconfig()
{
CONFIGFILE=$1
ETCDSERVER=$2
MASTERSERVER=$3
cat <<EOF> $CONFIGFILE
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
KUBE_MASTER="--master=$MASTERSERVER"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd_servers=$ETCDSERVER"
EOF
}


writekubelete()
{
KBLETFILE=$1
HOSTNAME=$2
APISERVER=$3
cat <<EOF> $KBLETFILE
###
# kubernetes kubelet (minion) config

# The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
KUBELET_HOSTNAME="--hostname_override=$HOSTNAME"

# location of the api-server
KUBELET_API_SERVER="--api_servers=$APISERVER"

# Add your own!
KUBELET_ARGS=""
EOF
}

writeipconfig()
{
KBRFILE=$1
KBRIP=$2
KBRMASK=$3
cat <<EOF> $KBRFILE
DEVICE=kbr0
ONBOOT=yes
BOOTPROTO=static
IPADDR=$KBRIP
NETMASK=255.255.255.0
GATEWAY=$KBRMASK
USERCTL=no
TYPE=Bridge
IPV6INIT=no
EOF
}


#get config and do the setting, openvswitch gre, route, ip, kubelete
CONFIGFILE='/srv/salt-data/minion-conf/minionlist.ini'
echo "Config setting by $CONFIGFILE"
profile=`sed -n '/minions/'p $CONFIGFILE | awk -F= '{print $2}' | sed 's/,/ /g'`
for OneCom in $profile
do
	echo "--------------------------------------------------"
	getconfig2setting  $OneCom  $CONFIGFILE
	#break
done
echo "Config setting done"
