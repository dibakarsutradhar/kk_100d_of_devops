# 🐳 Docker Compose Deployment Report

**Server:** App Server 2 (`stapp02`)
**User:** `steve`
**Objective:** Set up and verify a simple Dockerized web application using **Apache HTTPD** served on port **3003** with volume mapping from `/opt/sysops`.

---

## 🧩 Task Overview

The goal was to:

1. Install Docker and Docker Compose.
2. Create a `docker-compose.yml` file to run an `httpd` container.
3. Map local content from `/opt/sysops` to the Apache document root.
4. Expose the service on port `3003`.
5. Verify the setup using `curl`.

---

## ⚙️ Steps Performed

### 1. Navigated to the Docker directory

```bash
cd /opt/docker
```

### 2. Created Docker Compose configuration

```bash
sudo vi docker-compose.yml
```

### 3. Verified configuration file contents

```bash
cat docker-compose.yml
```

**`docker-compose.yml` content:**

```yaml
version: '3.8'

services:
  web:
    image: httpd:latest
    container_name: httpd
    ports:
      - "3003:80"
    volumes:
      - /opt/sysops:/usr/local/apache2/htdocs
```

---

### 4. Deployed the container

```bash
sudo docker compose -f docker-compose.yml up -d
```

**Output:**

```
WARN[0000] /opt/docker/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 7/7
 ✔ web Pulled                                                          6.0s 
   ✔ 8c7716127147 Pull complete                                        2.8s 
   ✔ af3b83c443ec Pull complete                                        3.1s 
   ✔ 4f4fb700ef54 Pull complete                                        3.5s 
   ✔ 6c19a85825c3 Pull complete                                        4.1s 
   ✔ 12844f4198f6 Pull complete                                        5.3s 
   ✔ fbb3c2cad9f8 Pull complete                                        5.8s 
[+] Running 2/2
 ✔ Network docker_default  Created                                     0.1s 
 ✔ Container httpd         Started                                     2.0s 
```

---

### 5. Checked running containers

```bash
sudo docker ps
```

**Output:**

```
CONTAINER ID   IMAGE          COMMAND              CREATED          STATUS          PORTS                  NAMES
cbfbc073659b   httpd:latest   "httpd-foreground"   13 seconds ago   Up 11 seconds   0.0.0.0:3003->80/tcp   httpd
```

---

### 6. Verified web service response

Since `netstat` and `ss` commands were not available, **verification was done using `curl`**:

```bash
curl localhost:3003
```

**Output:**

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /</title>
 </head>
 <body>
<h1>Index of /</h1>
<ul><li><a href="index1.html"> index1.html</a></li>
</ul>
</body></html>
```

✅ **Result:** Web service is accessible on port `3003`.

---

## ✅ Summary

| Checkpoint           | Status | Notes                                                      |
| -------------------- | ------ | ---------------------------------------------------------- |
| Docker Installed     | ✅      | Docker engine and Compose functional                       |
| Compose File Created | ✅      | Located at `/opt/docker/docker-compose.yml`                |
| Container Started    | ✅      | `httpd` running as expected                                |
| Service Verified     | ✅      | Accessible at `localhost:3003`                             |
| Network Verification | ✅      | Verified using `curl` (since `netstat` & `ss` unavailable) |

---

**Final Status:** 🟢 **Successful deployment and verification of Dockerized Apache HTTPD server.**

---
