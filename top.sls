base:
    # salt-master
    'kube-master':
      - kube-master
    'centos-minion*':
      - minion-packages
      - minion-conf
