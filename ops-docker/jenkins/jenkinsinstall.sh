
yum install java-1.7.0-openjdk

yum install git

yum install docker

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo

rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

yum install jenkins
