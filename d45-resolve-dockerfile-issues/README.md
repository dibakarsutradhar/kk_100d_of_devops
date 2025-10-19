# Fix and build Dockerfile for Apache (httpd) custom image  
**Environment:** App Server 1 (Stratos DC)  
**User:** tony  
**Date:** October 2025  

---

## 🧩 Task Description

The Nautilus DevOps team needed a **custom Docker image** built from a provided Dockerfile located in `/opt/docker/`.  
The initial build was failing, and the objective was to **fix the Dockerfile** and ensure the image builds successfully **without changing** the base image or key configuration.

### Requirements:
- Base Image: `httpd:2.4.43`
- Apache should listen on port **8080** (instead of 80)
- SSL modules and configurations must be enabled
- Certificates and HTML content must be copied properly
- The image must successfully build and serve the webpage

---

## 🧠 Problem Diagnosis

### Initial Dockerfile
```dockerfile
FROM httpd:2.4.43

RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

RUN sed -i '/LoadModule\ ssl_module modules\/mod_ssl.so/s/^#//g' conf/httpd.conf
RUN sed -i '/LoadModule\ socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' conf/httpd.conf
RUN sed -i '/Include\ conf\/extra\/httpd-ssl.conf/s/^#//g' conf/httpd.conf

RUN cp certs/server.crt /usr/local/apache2/conf/server.crt
RUN cp certs/server.key /usr/local/apache2/conf/server.key
RUN cp html/index.html /usr/local/apache2/htdocs/
```

### Issues Found:

1. **Incorrect relative paths** — `conf/httpd.conf` should be `/usr/local/apache2/conf/httpd.conf`.
2. **Using `RUN cp` for host files** — Files from the build context must be copied using `COPY` instructions, not `cp`.
3. **Build context missing files** — Certificates and HTML files were not available to the image before copying.
4. **Redundant commands** — Could be simplified, but minimal changes were applied to respect instructions.

---

## 🔧 Fixed Dockerfile

```dockerfile
FROM httpd:2.4.43

# Update Apache port
RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

# Enable SSL and include extra config
RUN sed -i '/LoadModule ssl_module modules\/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN sed -i '/Include conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy SSL certificates and HTML files from build context
COPY certs/server.crt /usr/local/apache2/conf/server.crt
COPY certs/server.key /usr/local/apache2/conf/server.key
COPY html/index.html /usr/local/apache2/htdocs/
```

---

## 💻 Dockerfile Execution Log

```bash
[tony@stapp01 docker]$ sudo docker build -t custom-httpd .
[sudo] password for tony: 
[+] Building 194.2s (11/11) FINISHED
 => [internal] load metadata for docker.io/library/httpd:2.4.43      124.0s
 => [2/6] RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/c  1.2s
 => [3/6] RUN sed -i '/LoadModule ssl_module modules\/mod_ssl.so/s/^#  1.3s
 => [4/6] COPY certs/server.crt /usr/local/apache2/conf/server.crt     1.1s
 => [5/6] COPY certs/server.key /usr/local/apache2/conf/server.key     1.0s
 => [6/6] COPY html/index.html /usr/local/apache2/htdocs/              1.0s
 => exporting to image                                                 1.6s
 => => naming to docker.io/library/custom-httpd                        0.0s

[tony@stapp01 docker]$ sudo docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
custom-httpd   latest    d98fc5915e52   19 seconds ago   166MB

[tony@stapp01 docker]$ sudo docker run -d -p 8080:8080 -p 8443:443 custom-httpd
4a58ca9ec750d973164dfa1963570c0ad24b3667f4f616c114fb3bd4abd7d26c

[tony@stapp01 docker]$ curl localhost:8080
This Dockerfile works!
```

---

## 🧾 Summary

| Step | Action                                            | Result                               |
| ---- | ------------------------------------------------- | ------------------------------------ |
| 1️⃣  | Reviewed Dockerfile                               | Found relative path & copy issues    |
| 2️⃣  | Corrected paths and replaced `RUN cp` with `COPY` | Build succeeded                      |
| 3️⃣  | Built custom image `custom-httpd`                 | ✅ Successful                         |
| 4️⃣  | Verified with `curl localhost:8080`               | Response: *“This Dockerfile works!”* |

---

## ✅ Final Outcome

* **Dockerfile fixed** and image built successfully.
* **Apache (httpd)** now listens on **port 8080**.
* **SSL modules** are enabled.
* Container verified functional via `curl`.
* Task completed and environment left in **running state**.

---

**Result:** ✔️ Task Completed Successfully
**Image:** `custom-httpd:latest`
**Container Port:** 8080 → Host Port 8080
**Verification:** HTTP response confirmed

---
