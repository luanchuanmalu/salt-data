#set ip
resultip==$(ip addr | grep kbr0)
if [[ "$resultip" != *$kbrip*brd* ]]
  then
  echo "set the ip for $SECTION"
  ip address add $kbrip/24 brd + dev kbr0
else
  echo "$SECTION already have the ip $kbrip";
fi
# set ip to the file
echo "set the ip file $kbripfile for $SECTION"
writeipconfig $kbripfile $kbrip $kbrgetway
# set kubelete
echo "set kubelet file $kubeletconf for $SECTION"
writekubelete $kubeletconf $hostname $api_server
# set kubernetes config etcd_server kubernetesconfig
echo "set kubernetes config file $kubernetesconfig for $SECTION"
writekubernetesconfig $kubernetesconfig $etcd_server $api_server
