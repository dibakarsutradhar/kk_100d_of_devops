# 🧾 Kubernetes Nginx + PHP-FPM Pod Configuration & Fix Report

## 🧩 Task Overview

The objective was to configure a **multi-container Pod** in Kubernetes running:

* **Nginx** (as a web server)
* **PHP-FPM** (to process PHP scripts)

Both containers should:

* Share a **common volume** for serving application files (`/var/www/html`)
* Use a **ConfigMap** to supply the Nginx configuration file

The issue initially observed was a **502 Bad Gateway** error between Nginx and PHP-FPM.

---

## 🧠 Root Cause

After analyzing the Pod and ConfigMap:

* The containers were running but **Nginx couldn’t communicate** with PHP-FPM.
* The **volume mount paths** were inconsistent (`/usr/share/nginx/html` vs `/var/www/html`).

---

## 🧰 Fix Implementation

### 1. Verified Current Resources

Checked Pod and ConfigMap status:

```bash
kubectl get pods
kubectl describe pod nginx-phpfpm
kubectl describe configmap nginx-config
```

### 2. Confirmed Pod YAML Export

Exported the running Pod definition:

```bash
kubectl get pod nginx-phpfpm -o yaml > definition.yml
```

Reviewed the file to confirm shared volume and container configurations.

---

### 3. Adjusted Pod Volume Mount Paths

Ensured both containers used the **same shared directory**:

```yaml
volumeMounts:
  - name: shared-files
    mountPath: /var/www/html
```

### 4. Validated ConfigMap (`nginx-config`)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 8099 default_server;
        listen [::]:8099 default_server;

        root /var/www/html;
        index index.html index.htm index.php;
        server_name _;
        location / {
          try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
          include fastcgi_params;
          fastcgi_param REQUEST_METHOD $request_method;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass 127.0.0.1:9000;
        }
      }
    }
```

---

### 5. Redeployed the Pod

Deleted the previous Pod and recreated from `definition.yml`:

```bash
kubectl delete pod nginx-phpfpm
kubectl create -f definition.yml
```

Verified the new Pod status:

```bash
kubectl get pods
```

**Output:**

```
NAME           READY   STATUS    RESTARTS   AGE
nginx-phpfpm   2/2     Running   0          13s
```

---

### 6. Uploaded PHP Test File

Copied `index.php` into the shared directory:

```bash
kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html -c nginx-container
```

---

## ✅ Final Verification

* Both containers were running and ready:

  ```
  READY   STATUS    RESTARTS   AGE
  2/2     Running   0          <age>
  ```

* The shared volume `/var/www/html` was mounted in both containers.

* The Nginx server served PHP pages via PHP-FPM successfully.

---

## 🧾 Final Pod Summary

| Component           | Image                | Role          | Mounted Path                             | Config Source             |
| ------------------- | -------------------- | ------------- | ---------------------------------------- | ------------------------- |
| `php-fpm-container` | `php:7.2-fpm-alpine` | PHP Processor | `/var/www/html`                          | Shared Volume             |
| `nginx-container`   | `nginx:latest`       | Web Server    | `/var/www/html`, `/etc/nginx/nginx.conf` | Shared Volume + ConfigMap |

---

## 💡 Lessons Learned

* Always ensure **consistent mount paths** across containers sharing files.
* Verify that **`fastcgi_pass`** in Nginx points to the correct PHP-FPM socket or address.
* Use `kubectl get -o yaml` before deleting any Pod to **preserve the configuration**.
* A ConfigMap can be dynamically mounted for Nginx without needing container rebuilds.

---

### ✅ Final Status: **Working Configuration**

| Checkpoint            | Status |
| --------------------- | ------ |
| Pod Running           | ✅      |
| Containers Ready      | ✅      |
| Shared Volume Mounted | ✅      |
| PHP Page Served       | ✅      |

---
