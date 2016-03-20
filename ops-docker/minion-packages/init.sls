#openvswitch install
/srv/salt-data/minion-packages/openvswitch:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - order: 1

/srv/salt-data/minion-packages/openvswitch/openvswitch-2.3.0-1.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/openvswitch/openvswitch-2.3.0-1.x86_64.rpm
    - require:
      - file: /srv/salt-data/minion-packages/openvswitch
    - order: 3

/srv/salt-data/minion-packages/openvswitch/openvswitchdb.sh:
  file:
    - managed
    - source: salt://minion-packages/openvswitch/openvswitchdb.sh
    - require:
      - file: /srv/salt-data/minion-packages/openvswitch
    - order: 4

openvswitch-extras-pkgs:
  pkg:
    - installed
    - names:
      - wget
      - kernel-devel
      - openssl-devel
      - socat
    - order: 5

openvswitch-setup:
  cmd.run:
    - unless: rpm -qa | grep openvswitch
    - name: 'yum -y localinstall openvswitch-2.3.0-1.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/openvswitch
    - require:
      - pkg: openvswitch-extras-pkgs
      - file: /srv/salt-data/minion-packages/openvswitch/openvswitch-2.3.0-1.x86_64.rpm
    - order: 6

openvswitch:
  pkg:
    - installed
    - require:
      - cmd: openvswitch-setup
    - order: 7

policycoreutils-packages:
  cmd.run:
    - unless: rpm -qa | grep policycoreutils
    - name: 'yum -y install policycoreutils*'
    - order: 8

/etc/openvswitch:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - order: 9

bridge-utils:
  pkg:
    - installed
    - order: 11
#kubenetes install
/srv/salt-data/minion-packages/kubernetes:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - order: 12

/srv/salt-data/minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 13

/srv/salt-data/minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 14

/srv/salt-data/minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 15

/srv/salt-data/minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 16

#docker install
docker:
  pkg:
    - installed
    - order: 17

kubernetes-client-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-client
    - name: 'yum -y localinstall kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 18

kubernetes-node-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-node
    - name: 'yum -y localinstall kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 19

kubernetes-master-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-master
    - name: 'yum -y localinstall kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 20

kubernetes-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-1.1.0
    - name: 'yum -y localinstall kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
      - cmd: kubernetes-master-setup
      - cmd: kubernetes-client-setup
      - cmd: kubernetes-node-setup
    - order: 21

kubernetes:
  pkg:
    - installed
    - require:
      - cmd: kubernetes-setup
    - order: 22

nginx:
  pkg:
    - installed
    - order: 23

# TODO: check the server is running
# parse the log maybe?
