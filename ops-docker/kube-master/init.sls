include:
  - minion-packages

etcd:
  pkg:
    - installed

/srv/salt-data/kube-master/scrpit/:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/kube-master/scrpit/RCNewDeploy.sh:
  file:
    - managed
    - source: salt://kube-master/scrpit/RCNewDeploy.sh

/srv/salt-data/kube-master/scrpit/RCDeploy.sh:
  file:
    - managed
    - source: salt://kube-master/scrpit/RCDeploy.sh

/srv/salt-data/kube-master/scrpit/RCReset.sh:
  file:
    - managed
    - source: salt://kube-master/scrpit/RCReset.sh

/srv/salt-data/kube-master/scrpit/Deploy_tmp.sh:
  file:
    - managed
    - source: salt://kube-master/scrpit/Deploy_tmp.sh

/srv/salt-data/kube-master/scrpit/test.sh:
  file:
    - managed
    - source: salt://kube-master/scrpit/test.sh



# TODO: check the server is running
# parse the log maybe?
