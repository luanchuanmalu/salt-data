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
			echo "set gre to $SECTION for $hostname"
			resultgre=$(ovs-vsctl show | grep $remoteip)
			if [[ "$resultgre" != *options* ]]
				then
				echo "add the gre port for $SECTION"
	      ovs-vsctl add-port obr0 $SECTION -- set Interface $SECTION type=gre options:remote_ip=$remoteip
			else
				echo "already exist the gre port $resultgre";
			fi

		else
			echo "set local ip kubelete and config for $hostname"
			#set ip
			resultip=$(ip addr | grep kbr0)
			if [[ "$resultip" != *$kbrip*brd* ]]
				then
				echo "set the ip for $SECTION = $kbrip"
				ip address add $kbrip/16 brd + dev kbr0
			else
				echo "$SECTION already have the ip $kbrip";
			fi

			#route part
			resultroute=$(ip route | grep $remoteip)
			if [[ "$resultroute" != *via* ]]
				then
				echo "add the route for $SECTION,kbrgetway=$kbrgetway, routedev=$routedev"
				ip route add $kbrgetway/16 dev $routedev
			else
				echo "already exist the route $resultroute";
			fi

		fi
	else
		echo "The end"
  fi
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
#make sure the obr0 and kbr0 up
ip link set dev obr0 up
ip link set dev kbr0 up
brctl addif kbr0 obr0
echo "Config setting done"
