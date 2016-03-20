base:
    # salt-master
    'centos7master':
      - kube-master
      - kube-master.task
    'docker-registry':
      - docker-registry
      - iptables.docker-registry
    'centos7minion*':
      - minion-packages
      - minion-conf
    'stage-master*':
      - minion-packages
      - kube-master
      - stage_kube-master
      - stage_minion-conf
      - stage_kube-master.task
