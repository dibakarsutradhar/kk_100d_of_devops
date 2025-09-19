#!/bin/bash

# Define app hosts and their respective users
declare -A APP_HOSTS
APP_HOSTS["stapp01"]="tony"
APP_HOSTS["stapp02"]="steve"
APP_HOSTS["stapp03"]="banner"

# Define LBR IP
LBR_IP="172.16.238.14"

# Create the fireware setup script dynamically
cat << EOF >  /tmp/secure_app_host.sh
#!/bin/bash
set -e

# Install iptables
sudo yum install -y iptables iptables-services

# Flush existing rules
sudo iptables -F

# Allow established/related
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow Apache only from LBR
sudo iptables -A INPUT -p tcp -s ${LBR_IP} --dport 3000 -j ACCEPT

# Drop everything else on port 3000
sudo iptables -A INPUT -p tcp --dport 3000 -j DROP

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Reject everything else (default deny)
sudo iptables -A INPUT -j REJECT

# Save rules
sudo service iptables save

# Enable iptables on boot
sudo systemctl enable iptables
sudo systemctl restart iptables
EOF

# Push and execute on each app host
for host in "${!APP_HOSTS[@]}"; do
    user=${APP_HOSTS[$host]}
    echo ">>> Securing $host as $user..."
    scp /tmp/secure_app_host.sh ${user}@${host}:/tmp/
    ssh ${user}@${host} "chmod +x /tmp/secure_app_host.sh && /tmp/secure_app_host.sh"
done

echo "✅ All app hosts secured."
