# Docker Compose (Web + DB Stack)

**Server:** App Server 1 (Stratos DC)
**User:** `tony`
**Directory:** `/opt/sysops/`
**File:** `docker-compose.yml`

---

## 🧩 Task Requirements

Set up a Docker Compose stack with:

* A **web service** using `php:apache`

  * Container name: `php_host`
  * Host port `8085` → Container port `80`
  * Volume: `/var/www/html`
* A **database service** using `mariadb:latest`

  * Container name: `mysql_host`
  * Host port `3306` → Container port `3306`
  * Volume: `/var/lib/mysql`
  * Environment variables for database creation and credentials

---

## ⚙️ Implementation

**Docker Compose File:**

```yaml
version: '3.8'

services:
  web:
    image: php:apache
    container_name: php_host
    ports:
      - "8085:80"
    volumes:
      - /var/www/html:/var/www/html
    depends_on:
      - db

  db:
    image: mariadb:latest
    container_name: mysql_host
    ports:
      - "3306:3306"
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    environment:
      MYSQL_DATABASE: database_host
      MYSQL_USER: appuser
      MYSQL_PASSWORD: Str0ngP@ssw0rd
      MYSQL_ROOT_PASSWORD: RootP@ss123
```

---

## 🚀 Deployment Logs

```bash
[tony@stapp01 sysops]$ sudo docker compose -f docker-compose.yml up -d
WARN[0000] /opt/sysops/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 25/25
 ✔ web Pulled                                                         67.3s 
 ✔ db Pulled                                                          24.5s 
 ✔ Network sysops_default  Created                                     0.1s 
 ✔ Container mysql_host    Started                                    13.1s 
 ✔ Container php_host      Started                                     9.1s 
```

---

## 🧮 Container Verification

```bash
[tony@stapp01 sysops]$ sudo docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS          PORTS                    NAMES
cb5cfaf9be14   php:apache       "docker-php-entrypoi…"   59 seconds ago       Up 50 seconds   0.0.0.0:8085->80/tcp     php_host
f6a820fde0d0   mariadb:latest   "docker-entrypoint.s…"   About a minute ago   Up 51 seconds   0.0.0.0:3306->3306/tcp   mysql_host
```

---

## ✅ Validation

```bash
[tony@stapp01 sysops]$ curl localhost:8085
<html>
    <head>
        <title>Welcome to xFusionCorp Industries!</title>
    </head>
    <body>
        Welcome to xFusionCorp Industries!
    </body>
</html>
```

**Result:**
✔ Both containers running successfully.
✔ Web application accessible at `localhost:8085`.
✔ Database container initialized with correct credentials.

---

## 🏁 Final Status

| Component          | Status    | Container  | Ports     | Image          |
| ------------------ | --------- | ---------- | --------- | -------------- |
| Web (PHP-Apache)   | ✅ Running | php_host   | 8085→80   | php:apache     |
| Database (MariaDB) | ✅ Running | mysql_host | 3306→3306 | mariadb:latest |

---
