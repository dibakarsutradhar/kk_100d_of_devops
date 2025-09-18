Our monitoring tool has reported an issue in Stratos Datacenter. One of our app servers has an issue, as its Apache service is not reachable on port 8085 (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.

Use tools like telnet, netstat, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.

Once fixed, you can test the same using command curl http://stapp01:8085 command from jump host.

Note: Please do not try to alter the existing index.html code, as it will lead to task failure.

---

## Apache Reachability Issue – Step-by-Step Resolution

**Scenario:** Apache service on `stapp01` (Stratos Datacenter) was not reachable on port 8085 from the jump host.

---

### **1. Verify service status**

* Checked Apache service status:

```bash
sudo systemctl status httpd
```

* Observed that Apache was **failing to start**.
* Error log indicated:

```
(98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8085
```

* Interpretation: **Another process was already using port 8085**, preventing Apache from binding.

---

### **2. Identify process occupying the port**

* Ran:

```bash
sudo netstat -tulnp | grep 8085
```

* Found that **Sendmail** was listening on `127.0.0.1:8085`.

* This explained why Apache could not start.

---

### **3. Resolve port conflict**

* Determined that Sendmail did not need to use 8085.
* Stopped and disabled Sendmail:

```bash
sudo systemctl stop sendmail
sudo systemctl disable sendmail
```

* This freed up port 8085.

---

### **4. Start Apache service**

* Restarted Apache:

```bash
sudo systemctl start httpd
sudo systemctl status httpd
```

* Apache started successfully and was listening on **0.0.0.0:8085**.

* Confirmed with:

```bash
sudo ss -tulnp | grep httpd
```

---

### **5. Test internal connectivity**

* From the app server itself:

```bash
curl http://localhost:8085
```

* Received expected response → Apache running correctly internally.

---

### **6. Test external connectivity**

* From the jump host:

```bash
telnet stapp01 8085
curl http://stapp01:8085
```

* Connection failed: **No route to host**.

* This indicated a **network/firewall block**.

---

### **7. Check server firewall rules**

* Checked iptables rules on the app server:

```bash
sudo iptables -L -n -v --line-numbers
```

* Found a **catch-all REJECT rule** in the INPUT chain blocking external connections to 8085.

---

### **8. Add rule to allow Apache port**

* Inserted ACCEPT rule **before the REJECT**:

```bash
sudo iptables -I INPUT <line-number-of-REJECT> -p tcp --dport 8085 -j ACCEPT
```

* Verified:

```bash
sudo iptables -L -n -v
```

---

### **9. Test connectivity again**

* From jump host:

```bash
telnet stapp01 8085
curl http://stapp01:8085
```

* Apache was now reachable externally.

---

### **10. Save iptables rules**

* Persisted the iptables rules so they survive a reboot:

```bash
sudo iptables-save > /etc/sysconfig/iptables
```

---

### ✅ **Summary of Root Causes and Fixes**

1. **Apache not starting** → Port 8085 already in use by Sendmail.
   **Fix:** Stop/disable Sendmail to free the port.

2. **Apache not reachable externally** → Firewall blocked port 8085.
   **Fix:** Insert iptables ACCEPT rule for TCP port 8085.

* After both fixes, Apache started successfully and was reachable from the jump host on port 8085.

---
