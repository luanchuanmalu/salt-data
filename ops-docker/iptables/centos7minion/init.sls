include:
  - iptables
/etc/sysconfig/iptables:
  file:
    - managed
    - source: salt://iptables/centos7minion/iptables
iptables:
  service.running:
    - enable: true
    - reload: True
    - watch:
      - file: /etc/sysconfig/iptables
    - require:
      - pkg: iptables-services
# TODO: check the server is running
# parse the log maybe?
