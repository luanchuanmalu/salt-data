/srv/salt-data/stage_kube-master/task:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/srv/salt-data/stage_kube-master/task/stage-mongo-a.json:
  file:
    - managed
    - source: salt://stage_kube-master/task/stage-mongo-a.json

/srv/salt-data/stage_kube-master/task/stage-mongo-svc.json:
  file:
    - managed
    - source: salt://stage_kube-master/task/stage-mongo-svc.json

/srv/salt-data/stage_kube-master/task/stage-web-a.json:
  file:
    - managed
    - source: salt://stage_kube-master/task/stage-web-a.json

/srv/salt-data/stage_kube-master/task/stage-web-b.json:
  file:
    - managed
    - source: salt://stage_kube-master/task/stage-web-b.json

/srv/salt-data/stage_kube-master/task/stage-web-svc.json:
  file:
    - managed
    - source: salt://stage_kube-master/task/stage-web-svc.json

# TODO: check the server is running
# parse the log maybe?
