#!/bin/bash
###
echo "SHALOM"
### fix httpd.conf
service httpd stop
sed -i '/^<VirtualHost/,+6 s/^/#/' /etc/httpd/conf/httpd.conf
### change mntlab to * in vhost.conf
sed -i 's/mntlab/*/g' /etc/httpd/conf.d/vhost.conf
### fix bachrc
sed -i '/export/s/^/# /' /home/tomcat/.bashrc
### change owner of logs folder in tomcat
chown tomcat:tomcat /opt/apache/tomcat/current/logs/
### switch java version
alternatives --config java <<<1
### fix mistakes in workers.properties
sed -i 's/192.168.56.100/192.168.56.10/' /etc/httpd/conf.d/workers.properties
sed -i 's/worker-jk@ppname/tomcat.worker/g' /etc/httpd/conf.d/workers.properties
### fix iptables
chattr -i /etc/sysconfig/iptables
cp -f /vagrant/sources/iptables /etc/sysconfig/
service iptables restart
chattr +i /etc/sysconfig/iptables
### Start Tomcat and httpd
service httpd start
service tomcat start
### ADD Tomcat to autorun
chkconfig --level 2345 tomcat on
echo "...This is the end..."
  
