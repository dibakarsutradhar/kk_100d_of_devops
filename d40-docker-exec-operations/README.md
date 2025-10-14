# Install and Configure Apache on Container
**Server:** Application Server 3
**Container Name:** `kkloud`
**OS:** CentOS 9 (Docker Host) / Ubuntu (Container)

---

## 📋 Task Description

A Nautilus DevOps team member was configuring services inside the **`kkloud`** container on **App Server 3** but went on leave before completing the setup.
The remaining configuration work needed to be completed by the DevOps team.

### **Requirements**

1. Install **Apache2** inside the `kkloud` container using **apt**.
2. Configure Apache to **listen on port 8084** instead of the default HTTP port (80).

   * It must listen on all interfaces (localhost, 127.0.0.1, container IP, etc.).
3. Ensure the **Apache service** is up and running inside the container.
4. Keep the **container running** after the configuration.

---

## ⚙️ Implementation Steps

### **1. Connect to Application Server 3**

```bash
ssh banner@stapp03
```

---

### **2. Verify the Running Container**

```bash
sudo docker ps
```

**Expected Output:**

```
CONTAINER ID   IMAGE           COMMAND       STATUS         NAMES
abcd1234ef56   ubuntu:latest   "/bin/bash"   Up 2 hours     kkloud
```

---

### **3. Access the Container Shell**

```bash
sudo docker exec -it kkloud bash
```

---

### **4. Update APT Repositories and Install Apache**

```bash
apt update -y
apt install -y apache2
```

Confirm Apache installation:

```bash
apache2 -v
```

**Expected Output:**

```
Server version: Apache/2.4.xx (Ubuntu)
```

---

### **5. Reconfigure Apache to Listen on Port 8084**

No text editor was available (`vi`, `nano`, `vim` not found),
so the configuration was modified using the `sed` command.

#### Update the main ports configuration:

```bash
sed -i 's/Listen 80/Listen 8084/' /etc/apache2/ports.conf
```

#### Update the default virtual host:

```bash
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8084>/' /etc/apache2/sites-available/000-default.conf
```

---

### **6. Restart Apache Service**

```bash
service apache2 restart
```

Verify Apache is running:

```bash
service apache2 status
```

**Expected Output:**

```
 * Apache2 is running (pid XXXX)
```

---

### **7. Verify Apache on Port 8084**

Since `netstat` and `ss` were unavailable, verification was done using **curl**:

```bash
curl -I http://localhost:8084
```

**Expected Output:**

```
HTTP/1.1 200 OK
Date: Fri, 10 Oct 2025 17:00:00 GMT
Server: Apache/2.4.xx (Ubuntu)
Content-Type: text/html; charset=UTF-8
```

This confirms Apache is actively serving traffic on port 8084.

---

### **8. Keep Container Running**

Exit the container without stopping it:

```bash
exit
```

Verify container state:

```bash
sudo docker ps
```

**Expected Output:**

```
kkloud   Up   ubuntu:latest
```

---

## ✅ Verification Summary

| Checkpoint        | Command                         | Result        |
| ----------------- | ------------------------------- | ------------- |
| Apache installed  | `apache2 -v`                    | ✔ Installed   |
| Port changed      | `cat /etc/apache2/ports.conf`   | ✔ Listen 8084 |
| Apache service    | `service apache2 status`        | ✔ Running     |
| Verified port     | `curl -I http://localhost:8084` | ✔ HTTP 200 OK |
| Container running | `sudo docker ps`                | ✔ Up          |

---

## 📦 Conclusion

Apache2 was successfully installed and configured inside the **`kkloud`** container on **App Server 3**.
The service was reconfigured to **listen on port 8084**, verified using `curl`, and confirmed to be running.
The container remains active and in a healthy state, meeting all task requirements.

---
