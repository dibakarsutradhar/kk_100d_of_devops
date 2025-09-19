# create automation script on jump_host
nano /tmp/secure_all_hosts.sh

# make it executable
chmod +x /tmp/secure_all_hosts.sh

# run it
bash /tmp/secure_all_hosts.sh

# verify from jump_host 
telnet stapp01 3000 # should fail

# verify from LBR
telnet stapp01 3000 # should pass
