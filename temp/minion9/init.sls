include:
  - minion-conf
#set ovs ip
/srv/salt-data/minion9:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/etc/sysconfig/network-scripts/ifcfg-kbr0:
  file:
    - managed
    - source: salt://minion9/ifcfg-kbr0

/etc/sysconfig/network-scripts/route-eno16777736:
  file:
    - managed
    - source: salt://minion9/route-eno16777736

/srv/salt-data/minion9/ipsetting-minion9.sh:
  file:
    - managed
    - source: salt://minion9/ipsetting-minion9.sh
    - require:
      - file: /srv/salt-data/minion9

/srv/salt-data/minion9/gresetting.sh:
  file:
    - managed
    - source: salt://minion9/gresetting.sh
    - require:
      - file: /srv/salt-data/minion9

/srv/salt-data/minion9/routesetting.sh:
  file:
    - managed
    - source: salt://minion9/routesetting.sh
    - require:
      - file: /srv/salt-data/minion9

ipsetting-minion9:
  cmd.run:
    - unless: ip addr | grep 172.17.9.1
    - name: 'sh ipsetting-minion9.sh'
    - cwd: /srv/salt-data/minion9
    - require:
      - pkg: openvswitch
      - file: /srv/salt-data/minion9/ipsetting-minion9.sh
      - service: openvswitch-service

openvswitch-gresetting:
  cmd.run:
    - unless: ovs-vsctl show | grep minion1
    - name: 'sh gresetting.sh'
    - cwd: /srv/salt-data/minion9
    - require:
      - pkg: openvswitch
      - file: /srv/salt-data/minion9/gresetting.sh
      - service: openvswitch-service

openvswitch-routesetting:
  cmd.run:
    - unless: ip route | grep 172.17.1.0
    - name: 'sh routesetting.sh'
    - cwd: /srv/salt-data/minion9
    - require:
      - pkg: openvswitch
      - file: /srv/salt-data/minion9/routesetting.sh
      - service: openvswitch-service

/etc/kubernetes/kubelet:
  file:
    - managed
    - source: salt://minion9/kubelet

kubelet:
  service.running:
    - name: kubelet
    - enable: true
    - reload: True
    - watch:
      - file: /etc/kubernetes/config
      - file: /etc/kubernetes/kubelet
    - require:
      - pkg: kubernetes

# TODO: check the server is running
# parse the log maybe?
