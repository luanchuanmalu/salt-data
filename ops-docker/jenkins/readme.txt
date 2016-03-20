when you install jenkins, here for your reference

1. firewall
2. /etc/sysconfig/jenkins  change port to 8088
3. permission, you can use jenkins user as root in /etc/sysconfig/jenkins
/etc/passwd
/etc/group
/etc/sudoers
# User privilege specification jenkins
root    ALL=(ALL:ALL) ALL
jenkins ALL=(ALL:ALL) ALL
usermod -G docker jenkins
4. start jenkins
/etc/init.d/jenkins restart
systemctl restart jenkins.service
5.
IF GFW http://xxxx:8088/pluginManager/available，
USE http://mirror.xmission.com/jenkins/updates/update-center.json
6. some plugin
SCM Sync Configuration Plugin ，GitHub plugin ，GIT plugin ，GIT client plugin
if can't install auto ,download from http://updates.jenkins-ci.org/download/plugins/ and install the hpi by upload in jenkins
7. set INSECURE_REGISTRY= to /etc/sysconfig/docker , then docker start
8. build bridge kbr0 and set -b=kbr0 to /etc/sysconfig/docker, make the docker worked when restart computer


#docker run -it -u root -v /var/lib/jenkins/workspace/stage_web_build:/opt/keystone 10.170.130.148:5000/keystone/web-build-env /bin/bas
