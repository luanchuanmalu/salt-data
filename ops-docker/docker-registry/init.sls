
/etc/sysconfig/docker-registry:
  file:
    - managed
    - source: salt://docker-registry/docker-registry

/etc/docker-registry.yml:
  file:
    - managed
    - source: salt://docker-registry/docker-registry.yml

docker-registry:
  pkg:
    - installed

docker-registry-service:
  service.running:
    - name: docker-registry
    - enable: true
    - reload: True
    - watch:
      - file: /etc/sysconfig/docker-registry
      - file: /etc/docker-registry.yml
    - require:
      - pkg: docker-registry
      - file: /etc/docker-registry.yml

# TODO: check the server is running
# parse the log maybe?
