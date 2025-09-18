# verify apache service status on stapp01
sudo systemctl status httpd
# (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085

# identify process occupying the port
sudo netstat -tulnp | grep 8085
# Sendmail was listening on 127.0.0.1:8085.

# resolve port conflict
sudo systemctl stop sendmail
sudo systemctl disable sendmail

# start apache server
sudo systemctl start httpd
sudo systemctl enable httpd
# verify it with
sudo netstat -tulnp | grep 8085

# test internal connectivity
curl http://localhost:8085

# test external connectivity from jump_host
curl http://stapp01:8085
telnet stapp01 8085
# Connection failed: No route to host. This indicated a network/firewall block.

# check server firewall rules
sudo iptables -L -n -v --line-numbers
# Found a catch-all REJECT rule in the INPUT chain blocking external connections to 8085

# add rule to allow apache port
sudo iptables -I INPUT <line-number-of-REJECT> -p tcp -dport 8085 -j ACCEPT

# verify
sudo iptables -L -n -v

# test connectivity again from jump_host
telnet stapp01 8085
curl http://stapp01:8085

# save iptables rules
sudo iptables save

