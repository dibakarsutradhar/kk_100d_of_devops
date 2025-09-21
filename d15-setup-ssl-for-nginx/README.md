# Report: Nginx Setup with SSL on App Server 3

## Objective

The system administrators of xFusionCorp Industries required setting up Nginx on **App Server 3** with SSL enabled using a self-signed certificate. The server also needed a simple HTML welcome page to verify deployment.

---

## Steps Performed

### 1. Install Nginx

Logged into **App Server 3 (`stapp03`)** as user `banner` and installed Nginx:

```sh
sudo yum install -y nginx
```

Enabled and started Nginx service:

```sh
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```

---

### 2. Configure SSL Certificates

The provided self-signed SSL certificate and key were located in `/tmp`:

* `/tmp/nautilus.crt`
* `/tmp/nautilus.key`

Moved them to the standard SSL directory:

```sh
sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
sudo chmod 600 /etc/nginx/ssl/nautilus.*
```

---

### 3. Update Nginx Configuration

Created a new SSL server block for HTTPS traffic.
Edited Nginx config (default path: `/etc/nginx/conf.d/ssl.conf`):

```sh
sudo vi /etc/nginx/conf.d/ssl.conf
```

Added:

```nginx
server {
    listen 443 ssl;

    server_name _;

    ssl_certificate     /etc/nginx/ssl/nautilus.crt;
    ssl_certificate_key /etc/nginx/ssl/nautilus.key;

    root /usr/share/nginx/html;
    index index.html;
}
```

Tested and reloaded Nginx:

```sh
sudo nginx -t
sudo systemctl reload nginx
```

---

### 4. Add Welcome Page

Created `index.html` in Nginx document root:

```sh
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html
```

---

### 5. Verification

From the **jump host**, tested HTTPS access using `curl`:

```sh
curl -Ik https://172.16.238.12
```

Output:

```
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Sun, 21 Sep 2025 17:19:49 GMT
Content-Type: text/html
Content-Length: 9
Last-Modified: Sun, 21 Sep 2025 17:18:46 GMT
Connection: keep-alive
ETag: "68d03376-9"
Accept-Ranges: bytes
```

This confirms:

* SSL is properly configured.
* Nginx is serving traffic over **port 443**.
* The welcome page is accessible.

---

## Final Status

* ✅ Nginx installed and enabled.
* ✅ SSL certificate and key deployed in `/etc/nginx/ssl/`.
* ✅ Welcome page served from `/usr/share/nginx/html/`.
* ✅ Verified with `curl` from jump host (200 OK response).

---

## Troubleshooting & Runbook

### 1. Nginx Fails to Start

* Run:

  ```sh
  sudo nginx -t
  ```

  to check for syntax errors.
* Check logs:

  ```sh
  sudo journalctl -xeu nginx
  sudo tail -f /var/log/nginx/error.log
  ```

### 2. SSL Errors (e.g., `SSL certificate problem`)

* Verify certificate and key paths in `/etc/nginx/ssl/ssl.conf`.
* Ensure permissions:

  ```sh
  sudo chmod 600 /etc/nginx/ssl/nautilus.*
  ```

### 3. SELinux Blocking Port 443

If SELinux is enabled, allow HTTPS traffic:

```sh
sudo setsebool -P httpd_can_network_connect 1
sudo semanage port -a -t http_port_t -p tcp 443
```

### 4. Firewall Blocking Access

If firewall is enabled, allow HTTPS:

```sh
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 5. Confirm Listening Ports

Check if Nginx is listening on port 443:

```sh
sudo netstat -tulnp | grep 443
```

---
