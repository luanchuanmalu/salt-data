include:
  - minion-packages
#openvswitch
/srv/salt-data/minion-conf/openvswitch:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/minion-conf/minionlist.ini:
  file:
    - managed
    - source: salt://minion-conf/minionlist.ini
    - require:
      - file: /srv/salt-data/minion-conf/openvswitch

/srv/salt-data/minion-conf/millionsetting.sh:
  file:
    - managed
    - source: salt://minion-conf/millionsetting.sh
    - require:
      - file: /srv/salt-data/minion-conf/openvswitch

/srv/salt-data/minion-conf/millionconfig.sh:
  file:
    - managed
    - source: salt://minion-conf/millionconfig.sh
    - require:
      - file: /srv/salt-data/minion-conf/openvswitch

/srv/salt-data/minion-conf/openvswitch/openvswitchbridge.sh:
  file:
    - managed
    - source: salt://minion-conf/openvswitch/openvswitchbridge.sh
    - require:
      - file: /srv/salt-data/minion-conf/openvswitch

openvswitch-service:
  service.running:
    - name: openvswitch
    - enable: true
    - require:
      - pkg: openvswitch
#docker
/etc/sysconfig/docker:
  file:
    - managed
    - source: salt://minion-conf/docker

#openswitch bridge
openvswitch-bridge:
  cmd.run:
    - unless: ip addr | grep obr0
    - name: 'sh openvswitchbridge.sh'
    - cwd: /srv/salt-data/minion-conf/openvswitch
    - require:
      - pkg: openvswitch
      - file: /srv/salt-data/minion-conf/openvswitch/openvswitchbridge.sh
      - service: openvswitch-service

/etc/hosts:
  file:
    - managed
    - source: salt://minion-conf/hosts

million-setting:
  cmd.run:
    - name: 'sh millionsetting.sh'
    - cwd: /srv/salt-data/minion-conf
    - require:
      - file: /srv/salt-data/minion-conf/millionsetting.sh
      - file: /srv/salt-data/minion-conf/minionlist.ini
      - service: openvswitch-service
#millionconfig
million-config:
  cmd.run:
    - name: 'sh millionconfig.sh'
    - cwd: /srv/salt-data/minion-conf
    - require:
      - file: /srv/salt-data/minion-conf/millionconfig.sh
      - file: /srv/salt-data/minion-conf/minionlist.ini
      - service: openvswitch-service

docker-service:
  service.running:
    - name: docker
    - enable: true
    - reload: True
    - watch:
      - file: /etc/sysconfig/docker
    - require:
      - pkg: docker
      - cmd: openvswitch-bridge

#copy some docker images
/srv/salt-data/minion-conf/dockerimages:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/minion-conf/dockerimages/dockio_pause.tar:
  file:
    - managed
    - source: salt://minion-conf/dockerimages/dockio_pause.tar
    - require:
      - file: /srv/salt-data/minion-conf/dockerimages

/srv/salt-data/minion-conf/dockerimages/gcr_pause.tar:
  file:
    - managed
    - source: salt://minion-conf/dockerimages/gcr_pause.tar
    - require:
      - file: /srv/salt-data/minion-conf/dockerimages

/srv/salt-data/minion-conf/dockerimages/loadimages.sh:
  file:
    - managed
    - source: salt://minion-conf/dockerimages/loadimages.sh
    - require:
      - file: /srv/salt-data/minion-conf/dockerimages

docker-image:
  cmd.run:
    - unless: docker images | grep gcr.io
    - name: 'sh loadimages.sh'
    - cwd: /srv/salt-data/minion-conf/dockerimages
    - require:
      - pkg: openvswitch
      - file: /srv/salt-data/minion-conf/dockerimages/loadimages.sh
      - service: docker-service


kube-proxy:
  service.running:
    - name: kube-proxy
    - enable: true
    - require:
      - pkg: kubernetes

kubelet:
  service.running:
    - name: kubelet
    - enable: true
    - require:
      - pkg: kubernetes
# TODO: check the server is running
# parse the log maybe?
