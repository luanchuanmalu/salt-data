
yum install docker-registry

firewall-cmd --zone=public --add-port=5000/tcp --permanent
firewall-cmd --reload

systemctl enable docker-registry
systemctl restart docker-registry
