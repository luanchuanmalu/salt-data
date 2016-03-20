include:
  - kube-master
  
/srv/salt-data/kube-master/install:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/kube-master/install/kubemasterinstall.sh:
  file:
    - managed
    - source: salt://kube-master/install/kubemasterinstall.sh

kubemasterinstall:
  cmd.run:
    - name: 'sh kubemasterinstall.sh'
    - cwd: /srv/salt-data/kube-master/install/
    - require:
      - file: /srv/salt-data/kube-master/install/kubemasterinstall.sh

etcd:
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

# TODO: check the server is running
# parse the log maybe?
