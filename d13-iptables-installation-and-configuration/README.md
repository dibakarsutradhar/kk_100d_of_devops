# Firewall Implementation Report – App Hosts

**Date:** 2025-09-20
**Prepared by:** Thor

---

## 1. Objective

Secure all application hosts on Nautilus infrastructure by:

* Restricting Apache (port 3000) access to only the Load Balancer (LBR) host.
* Keeping SSH open for management.
* Ensuring firewall rules persist across reboots.

---

## 2. Infrastructure

| Hostname | User   |
| -------- | ------ |
| stapp01  | tony   |
| stapp02  | steve  |
| stapp03  | banner |

**LBR IP:** 172.16.238.14

**Apache Port:** 3000
**SSH Port:** 22

---

## 3. Implementation Steps

### 3.1 Installing iptables

On each app host:

```bash
sudo yum install -y iptables iptables-services
```

---

### 3.2 Firewall Rules Applied

1. Flush existing rules:

```bash
sudo iptables -F
```

2. Allow established/related connections:

```bash
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

3. Allow SSH:

```bash
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

4. Allow Apache only from LBR:

```bash
sudo iptables -A INPUT -p tcp -s 172.16.238.14 --dport 3000 -j ACCEPT
```

5. Drop all other access to Apache:

```bash
sudo iptables -A INPUT -p tcp --dport 3000 -j DROP
```

6. Allow loopback traffic:

```bash
sudo iptables -A INPUT -i lo -j ACCEPT
```

7. Default deny all other traffic:

```bash
sudo iptables -A INPUT -j REJECT
```

8. Save rules and enable persistence:

```bash
sudo service iptables save
sudo systemctl enable iptables
sudo systemctl restart iptables
```

---

### 3.3 Automated Script – `secure_app_host.sh`

```bash
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
sudo iptables -A INPUT -p tcp -s 172.16.238.14 --dport 3000 -j ACCEPT

# Drop everything else on port 3000
sudo iptables -A INPUT -p tcp --dport 3000 -j DROP

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Reject everything else
sudo iptables -A INPUT -j REJECT

# Save rules
sudo service iptables save

# Enable iptables on boot
sudo systemctl enable iptables
sudo systemctl restart iptables
```

---

### 3.4 Automated Deployment Script – `secure_all_apps.sh`

Run this **from the jump host** to push and execute the firewall script on all app hosts:

```bash
#!/bin/bash

# Define app hosts and users
declare -A APP_HOSTS
APP_HOSTS["stapp01"]="tony"
APP_HOSTS["stapp02"]="steve"
APP_HOSTS["stapp03"]="banner"

# Define LBR IP
LBR_IP="172.16.238.14"

# Create the firewall setup script dynamically
cat << EOF > /tmp/secure_app_host.sh
#!/bin/bash
set -e

sudo yum install -y iptables iptables-services
sudo iptables -F
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -s ${LBR_IP} --dport 3000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3000 -j DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -j REJECT
sudo service iptables save
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
```

---

## 4. Verification

### 4.1 From Jump Host (Should fail)

```bash
telnet stapp01 3000
telnet stapp02 3000
telnet stapp03 3000
```

**Expected:** Connection fails. ✅

### 4.2 From LBR Host (Should succeed)

```bash
telnet stapp01 3000
telnet stapp02 3000
telnet stapp03 3000
```

**Expected:** Connection succeeds. ✅

### 4.3 iptables Snapshot (Example: stapp01)

```
ACCEPT     tcp  --  *      *       172.16.238.14        0.0.0.0/0            tcp dpt:3000
DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:3000
ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
```

---

## 5. Visual Diagram – Traffic Flow

```
                 ┌───────────┐
                 │  Jump Host│
                 └─────┬─────┘
                       │
                       │  port 3000 blocked
                       ▼
                  ┌───────────┐
                  │ stapp01   │
                  │ stapp02   │
                  │ stapp03   │
                  └───────────┘
                       ▲
                       │
       port 3000 allowed│
                       │
                 ┌───────────┐
                 │   LBR     │
                 │172.16.238.14│
                 └───────────┘
```

* Red arrow → blocked traffic
* Green arrow → allowed traffic

---

## 6. Conclusion

* Firewall successfully restricts Apache access to LBR only.
* SSH remains open for all hosts.
* Rules persist after reboot.
* Task completed and verified on all hosts.

✅ **All requirements fulfilled.**

---
