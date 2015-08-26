echo "start loadimages"
docker load --input /srv/salt-data/minion-conf/dockerimages/dockio_pause.tar
docker load --input /srv/salt-data/minion-conf/dockerimages/gcr_pause.tar
echo "end loadimages"
