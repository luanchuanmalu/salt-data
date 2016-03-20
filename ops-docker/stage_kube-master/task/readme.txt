#cmd
cd /srv/salt-data/stage_kube-master/task/
kubectl create -f stage-keystone-mongo-a.json
kubectl create -f stage-keystone-mongo-svc.json

#jenkins
app=stage-web
dockerdr=10.170.130.148:5000/keystone
echo $WORKSPACE


docker run -u root --rm -v $WORKSPACE:/opt/keystone 10.170.130.148:5000/keystone/web-build-env sh -c "cd /opt/keystone; ./build.sh"

docker build -t="$dockerdr/$app:v$BUILD_NUMBER" $WORKSPACE
docker push $dockerdr/$app:v$BUILD_NUMBER

docker tag -f $dockerdr/$app:v$BUILD_NUMBER $dockerdr/$app:latest
docker push $dockerdr/$app:latest

docker rmi $dockerdr/$app:v$BUILD_NUMBER
docker rmi $dockerdr/$app:latest


-------
kubectl create -f $taskpath/$groupa
kubectl create -f $taskpath/$groupb
kubectl create -f $taskpath/$svcname

kubectl scale --replicas=1 replicationcontrollers hellogroupa
kubectl scale --replicas=1 replicationcontrollers hellogroupb

kubectl label node stage-master label=stageminion1


docker exec -it 6a8bf299db70 /bin/sh
cat /usr/share/nginx/html/index.html
