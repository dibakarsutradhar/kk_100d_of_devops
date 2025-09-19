We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now Apache’s port i.e 3000 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:



1. Install iptables and all its dependencies on each app host.


2. Block incoming port 3000 on all apps for everyone except for LBR host.


3. Make sure the rules remain, even after system reboot.

thor@jumphost ~$ nano /tmp/secure_all_apps.sh 
thor@jumphost ~$ cat /tmp/secure_all_apps.sh 
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
thor@jumphost ~$ chmod +x /tmp/secure_all_apps.sh 
thor@jumphost ~$ bash /tmp/secure_all_apps.sh 
>>> Securing stapp01 as tony...
tony@stapp01's password: 
secure_app_host.sh                                                                              100%  740     2.2MB/s   00:00    
tony@stapp01's password: 
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required
>>> Securing stapp03 as banner...
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ED25519 key fingerprint is SHA256:Cr9sGflZZcYFT89MabdRO7Xflv90KAQl05qLcInKClU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp03' (ED25519) to the list of known hosts.
banner@stapp03's password: 
Permission denied, please try again.
banner@stapp03's password: 
secure_app_host.sh                                                                              100%  740     2.6MB/s   00:00    
banner@stapp03's password: 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required
>>> Securing stapp02 as steve...
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ED25519 key fingerprint is SHA256:oj66aj5VNu73fAZ7pjsy+yD274UK1p0COk+OI9Z3sUM.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'stapp02' (ED25519) to the list of known hosts.
steve@stapp02's password: 
secure_app_host.sh                                                                              100%  740     1.6MB/s   00:00    
steve@stapp02's password: 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
sudo: a password is required
✅ All app hosts secured.
thor@jumphost ~$ nano /tmp/secure_all_apps.sh 
thor@jumphost ~$ chmod +x /tmp/secure_all_apps.sh 
thor@jumphost ~$ bash /tmp/secure_all_apps.sh 
>>> Securing stapp01 as tony...
tony@stapp01's password: 
secure_app_host.sh                                                                              100%  740     1.2MB/s   00:00    
tony@stapp01's password: 
[sudo] password for tony: 
Last metadata expiration check: 0:13:56 ago on Fri Sep 19 18:08:42 2025.
Package iptables-legacy-1.8.10-11.1.el9.x86_64 is already installed.
Dependencies resolved.
==================================================================================================================================
 Package                              Architecture              Version                             Repository               Size
==================================================================================================================================
Installing:
 iptables-services                    noarch                    1.8.10-11.1.el9                     epel                     17 k

Transaction Summary
==================================================================================================================================
Install  1 Package

Total download size: 17 k
Installed size: 27 k
Downloading Packages:
iptables-services-1.8.10-11.1.el9.noarch.rpm                                                      106 kB/s |  17 kB     00:00    
----------------------------------------------------------------------------------------------------------------------------------
Total                                                                                              36 kB/s |  17 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                          1/1 
  Installing       : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Running scriptlet: iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Verifying        : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 

Installed:
  iptables-services-1.8.10-11.1.el9.noarch                                                                                        

Complete!
iptables: Saving firewall rules to /etc/sysconfig/iptables: [  OK  ]
Created symlink /etc/systemd/system/multi-user.target.wants/iptables.service → /usr/lib/systemd/system/iptables.service.
Connection to stapp01 closed.
>>> Securing stapp03 as banner...
banner@stapp03's password: 
secure_app_host.sh                                                                              100%  740     1.1MB/s   00:00    
banner@stapp03's password: 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for banner: 
CentOS Stream 9 - BaseOS                                                                           39 kB/s | 7.3 kB     00:00    
CentOS Stream 9 - BaseOS                                                                          3.0 MB/s | 8.8 MB     00:02    
CentOS Stream 9 - AppStream                                                                        34 kB/s | 7.5 kB     00:00    
CentOS Stream 9 - AppStream                                                                       1.9 MB/s |  25 MB     00:12    
CentOS Stream 9 - Extras packages                                                                  20 kB/s | 8.0 kB     00:00    
CentOS Stream 9 - Extras packages                                                                  67 kB/s |  20 kB     00:00    
Docker CE Stable - x86_64                                                                          30 kB/s | 2.0 kB     00:00    
Docker CE Stable - x86_64                                                                          63 kB/s |  54 kB     00:00    
Extra Packages for Enterprise Linux 9 - x86_64                                                    116 kB/s |  34 kB     00:00    
Extra Packages for Enterprise Linux 9 - x86_64                                                     22 MB/s |  20 MB     00:00    
Extra Packages for Enterprise Linux 9 openh264 (From Cisco) - x86_64                              5.6 kB/s | 993  B     00:00    
Extra Packages for Enterprise Linux 9 - Next - x86_64                                              81 kB/s |  24 kB     00:00    
Package iptables-legacy-1.8.10-11.1.el9.x86_64 is already installed.
Dependencies resolved.
==================================================================================================================================
 Package                              Architecture              Version                             Repository               Size
==================================================================================================================================
Installing:
 iptables-services                    noarch                    1.8.10-11.1.el9                     epel                     17 k

Transaction Summary
==================================================================================================================================
Install  1 Package

Total download size: 17 k
Installed size: 27 k
Downloading Packages:
iptables-services-1.8.10-11.1.el9.noarch.rpm                                                       85 kB/s |  17 kB     00:00    
----------------------------------------------------------------------------------------------------------------------------------
Total                                                                                              29 kB/s |  17 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                          1/1 
  Installing       : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Running scriptlet: iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Verifying        : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 

Installed:
  iptables-services-1.8.10-11.1.el9.noarch                                                                                        

Complete!
iptables: Saving firewall rules to /etc/sysconfig/iptables: [  OK  ]
Created symlink /etc/systemd/system/multi-user.target.wants/iptables.service → /usr/lib/systemd/system/iptables.service.
Connection to stapp03 closed.
>>> Securing stapp02 as steve...
steve@stapp02's password: 
secure_app_host.sh                                                                              100%  740     1.2MB/s   00:00    
steve@stapp02's password: 

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
Last metadata expiration check: 0:21:52 ago on Fri Sep 19 18:01:56 2025.
Package iptables-legacy-1.8.10-11.1.el9.x86_64 is already installed.
Dependencies resolved.
==================================================================================================================================
 Package                              Architecture              Version                             Repository               Size
==================================================================================================================================
Installing:
 iptables-services                    noarch                    1.8.10-11.1.el9                     epel                     17 k

Transaction Summary
==================================================================================================================================
Install  1 Package

Total download size: 17 k
Installed size: 27 k
Downloading Packages:
iptables-services-1.8.10-11.1.el9.noarch.rpm                                                       72 kB/s |  17 kB     00:00    
----------------------------------------------------------------------------------------------------------------------------------
Total                                                                                              38 kB/s |  17 kB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                          1/1 
  Installing       : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Running scriptlet: iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 
  Verifying        : iptables-services-1.8.10-11.1.el9.noarch                                                                 1/1 

Installed:
  iptables-services-1.8.10-11.1.el9.noarch                                                                                        

Complete!
iptables: Saving firewall rules to /etc/sysconfig/iptables: [  OK  ]
Created symlink /etc/systemd/system/multi-user.target.wants/iptables.service → /usr/lib/systemd/system/iptables.service.
Connection to stapp02 closed.
✅ All app hosts secured.
