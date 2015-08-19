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
    - order: 2

/srv/salt-data/minion-packages/kubernetes:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - order: 3

/srv/salt-data/minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 4

/srv/salt-data/minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 5

/srv/salt-data/minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 6

/srv/salt-data/minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm:
  file:
    - managed
    - source: salt://minion-packages/kubernetes/kubernetes-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 7

update-repo:
  cmd.run:
    - name: 'yum -y update'
    - order: 8

docker:
  pkg:
    - installed
    - order: 9

openvswitch-extras-pkgs:
  pkg:
    - installed
    - names:
      - wget
      - kernel-devel
      - openssl-devel
      - socat
    - order: 10

openvswitch-setup:
  cmd.run:
    - unless: rpm -qa | grep openvswitch
    - name: 'yum -y localinstall openvswitch-2.3.0-1.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/openvswitch
    - require:
      - pkg: openvswitch-extras-pkgs
      - file: /srv/salt-data/minion-packages/openvswitch/openvswitch-2.3.0-1.x86_64.rpm
    - order: 11

openvswitch:
  pkg:
    - installed
    - require:
      - cmd: openvswitch-setup
    - order: 12

kubernetes-node-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-node
    - name: 'yum -y localinstall kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-node-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 13

kubernetes-client-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-client
    - name: 'yum -y localinstall kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-client-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 14

kubernetes-master-setup:
  cmd.run:
    - unless: rpm -qa | grep kubernetes-master
    - name: 'yum -y localinstall kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm'
    - cwd: /srv/salt-data/minion-packages/kubernetes
    - require:
      - file: /srv/salt-data/minion-packages/kubernetes/kubernetes-master-1.1.0-0.4.git2bfa9a1.el7.x86_64.rpm
    - order: 15

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
    - order: 16

kubernetes:
  pkg:
    - installed
    - require:
      - cmd: kubernetes-setup
    - order: 17
# TODO: check the server is running
# parse the log maybe?
