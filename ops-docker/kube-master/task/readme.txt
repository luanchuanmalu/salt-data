kubectl create -f /srv/keystone-ops-salt/kube-master/task/hello-controller1.json
kubectl create -f /srv/keystone-ops-salt/kube-master/task/hello-controller2.json
kubectl create -f /srv/keystone-ops-salt/kube-master/task/hello-service.json

groupa=keystone-web-a.json
groupb=keystone-web-b.json
svcname=keystone-web-svc.json
taskpath=/srv/keystone-ops-salt/kube-master/task

kubectl create -f $taskpath/$groupa
kubectl create -f $taskpath/$groupb
kubectl create -f $taskpath/$svcname

kubectl scale --replicas=1 replicationcontrollers hellogroupa
kubectl scale --replicas=1 replicationcontrollers hellogroupb

kubectl label node stage-master label=stageminion1


docker exec -it 6a8bf299db70 /bin/sh
cat /usr/share/nginx/html/index.html
