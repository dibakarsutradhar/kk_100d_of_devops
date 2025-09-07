sudo vi /etc/ssh/sshd_config
## this opens the ssh_config file in the vim editor
## find this line
PermitRootLogin yes
## edit the line to 
PermitRootLogin no
## save the file and exit the editor
## restart the server
sudo service sshd restart
## root logins over SSH should now be disabled
