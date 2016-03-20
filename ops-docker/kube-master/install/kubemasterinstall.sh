#yum -y localinstall /srv/keystone-ops-salt/minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm

#yum -y localinstall /srv/keystone-ops-salt/minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm

#yum -y localinstall /srv/keystone-ops-salt/minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm

#yum -y localinstall /srv/keystone-ops-salt/minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm


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

writekubernetesapiserver()
{
CONFFILE=$1
ETCDSERVER=$2
cat <<EOF> ${CONFFILE}
###
# kubernetes system config
#
# The following values are used to configure the kube-apiserver
#

# The address on the local server to listen to.
KUBE_API_ADDRESS="--address=0.0.0.0"

# The port on the local server to listen on.
KUBE_API_PORT="--port=8080"


# Port minions listen on
KUBELET_PORT="--kubelet_port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd_servers=${ETCDSERVER}"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/24"

# default admission control policies
#KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

# Add your own!
KUBE_API_ARGS="--v=4"

EOF
}

#write the apiserver and config
etcd_server="http://centos7master:4001"
master_server="http://centos7master:8080"
kubernetesconfig="/etc/kubernetes/config"
kubernetesapiserver="/etc/kubernetes/apiserver"
writekubernetesconfig $kubernetesconfig  $master_server $etcd_server
writekubernetesapiserver $kubernetesapiserver $etcd_server
# start the service
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl restart $SERVICES
done
