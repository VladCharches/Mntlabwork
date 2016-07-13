N | Issue | How to find | Time to find min.|How to fix|Time to fix min.
|---|---|:---:|:---:|:---:|:---:|
1 | The site doesn't work |Connected to VM. Check ip of VM with ifconfig.Checked with curl -IL ip which I knew(192.168.56.10) from host and VM | 3 | Checked site status | 10 | 
2 | Recieved 302, 502 errors from VM and 302 from host. Redirect doesn't work | with curl -IL IP | 5 | Examine httpd.conf of Apache | 10 |    
3 | Saw one vhost in httpd.conf with redirect to mntlab and include conf.d/*.conf | Read httpd.conf and vhost.conf | 10 | Open vhost.conf saw also virtual host there. Commented vhost with redirect to http://mntlab in httpd.conf. Restarted httpd service | 3 |    
4 | I haven't request to virtual host from VM and Host machines | curl - IL ip from VM and Host machines. I should cheked log files. I found in /var/log/httpd/ many log files. I cheked right names of log files in vhost.conf and in httpd.conf. | 15 | I put instead of the mntlab:80  *:80 in vhost.conf. Restarted httpd. I recieved 503 error from VM and Host | 5 |
5 | Issue with Tomcat |  I started service tomcat start and checked status  "ps -ef grep tomcat". Service didn't start. I entered to etc/init.d/tomcat.Tried execute su - tomcat -c "sh /opt/apache/tomcat//current/bin/startup.sh" but it didn't work. I opened startup.sh and found where located catalina.sh. It located in the the same folder where startup.sh. I opened ctalaina.sh and didn't find $catalina_home | 2 | switch to tomcat user, echo $CATALINA_HOME, check it from bash_profile  bash rc, comment it, (swith to root and startup.sh) | 20 | 
6 | catalina.out: Permission denied | I checked ls -ld /path to tomcat/logs (root is owner) | 5 | chown tomcat folder. starting tomcat | 20 |
7 | Tomcat showed started, but not running | ps -ef grep tomcat checked ctatlina.out, found trouble with java | 10 | I checked java -version and Os version. Different bits OS (64 bit), java (32 bit) Switched java version by alternatives. Start tomcat. ps-ef grep tomcat, checked netstat -natpl curl from host(503), checked vhost.conf, found mod_jk, issue with tomcat.worker | 15|
8 | Connetction to tomcat failed | I cheked worker.properties and found mistakes | 10 | I edited worker.properties by sed  /etc/httpd/conf.d/workers.properties. Restarted httpd. Checked by curl. Site online. | 15 |
9 | Problem with iptables | I cheked service iptables status (-L -n) Tried to edit iptable's config. Permission denied  | 2 |   Checked atributes (lsattr iptables config) Switched off immutable flag chattr -i. Added 80 port and ESTABLISHED. start iptables and checked status -L -n | 25 |
10 | Autostart Tomcat | Checked chkconfig | 1 | Edited level in chkconfig (chkconfig --level (2345) tomcat on) restarted VM. Everything Started. | 5 |


Answers on additional questions:

What java version is installed?
 Run command "java -version" 
  java version "1.7.0_79" 
  Java(TM) SE Runtime Environment (build 1.7.0_79-b15) 
  Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode) 
  
How was it installed and configured?
It has been installed installed by unzipping rpm
Java has been configured with "alternatives"

Where are log files of tomcat and httpd?
