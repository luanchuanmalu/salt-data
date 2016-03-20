because currently the kube-master install on same server with salt-master, so this part is not really worked now.

for the kube-master install you can do manually by the instructuction in the folder "install".

the script and the tasks will trigger by the jenkins job "keystone-ops-salt" to move it in the right place,
so if you change the script and task file, you need run the jenkins job to make it on the server.

docker rm $(docker ps -a -q)
docker rmi $(docker images -q -f dangling=true)
