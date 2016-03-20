include:
  - kube-master

/srv/salt-data/stage_kube-master/install:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/stage_kube-master/install/etcdinstall.sh:
  file:
    - managed
    - source: salt://kube-master/install/etcdinstall.sh

/srv/salt-data/stage_kube-master/install/kubemasterinstall.sh:
  file:
    - managed
    - source: salt://stage_kube-master/install/kubemasterinstall.sh

etcdinstall:
  cmd.run:
    - name: 'sh etcdinstall.sh'
    - cwd: /srv/salt-data/stage_kube-master/install/
    - require:
      - file: /srv/salt-data/stage_kube-master/install/etcdinstall.sh

kubemasterinstall:
  cmd.run:
    - name: 'sh kubemasterinstall.sh'
    - cwd: /srv/salt-data/stage_kube-master/install/
    - require:
      - file: /srv/salt-data/stage_kube-master/install/kubemasterinstall.sh
      
/etc/hosts:
  file:
    - managed
    - source: salt://stage_minion-conf/hosts

etcd-service:
  service.running:
    - name: etcd
    - enable: true
    - require:
      - pkg: etcd

kube-apiserver:
  service.running:
    - name: kube-apiserver
    - enable: true
    - require:
      - pkg: kubernetes

kube-scheduler:
  service.running:
    - name: kube-scheduler
    - enable: true
    - require:
      - pkg: kubernetes

kube-controller-manager:
  service.running:
    - name: kube-controller-manager
    - enable: true
    - require:
      - pkg: kubernetes

# TODO: check the server is running
# parse the log maybe?
