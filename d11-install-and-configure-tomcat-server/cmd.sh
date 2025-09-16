# login into app server 02
ssh steve@stapp02

# install tomcat
sudo yum install tomcat -y

# configure tomcat to run on port 6000
# open the tomcat configuration file using vim
sudo vi /etc/tomcat/server.xml

# inside `server.xml` locat <Connector Port="8086" protocol="HTTP/1.1"
# change the port value to "6000"
# save the file

# open a second terminal (jump_host)
# copy ROOT.war from jump serer to app server 02 /tmp directory
scp /tmp/ROOT.war steve@stapp02:/tmp

# return to stapp02 terminal
# move the ROOT.war to tomcat/webapps directory
sudo mv /tmp/ROOT.war /var/lib/tomcat/webapps/

# restart the tomcat server
sudo systemctl restart tomcat

# verify the webpage works directly on the base URL
curl -i http://stapp02:6000
