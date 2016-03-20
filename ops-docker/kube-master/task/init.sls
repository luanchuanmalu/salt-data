/srv/salt-data/kube-master/task:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/kube-master/task/keystone-mongo-a.json:
  file:
    - managed
    - source: salt://kube-master/task/keystone-mongo-a.json

/srv/salt-data/kube-master/task/keystone-mongo-svc.json:
  file:
    - managed
    - source: salt://kube-master/task/keystone-mongo-svc.json

/srv/salt-data/kube-master/task/stage-keystone-web-a.json:
  file:
    - managed
    - source: salt://kube-master/task/keystone-web-a.json

/srv/salt-data/kube-master/task/keystone-web-b.json:
  file:
    - managed
    - source: salt://kube-master/task/stage-keystone-web-b.json

/srv/salt-data/kube-master/task/keystone-web-svc.json:
  file:
    - managed
    - source: salt://kube-master/task/keystone-web-svc.json

# TODO: check the server is running
# parse the log maybe?
