# Report: Nginx Load Balancer Configuration on LBR Server

## Objective

The Nautilus production support team needed to configure a **high availability load balancer (LBR)** to distribute traffic across the application servers. This ensures improved website performance and reliability.

---

## Steps Performed

### 1. Install Nginx on LBR Server

```bash
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

---

### 2. Verify Apache Ports on App Servers

The application servers were configured to run Apache on **port 5004**.

On each app server:

```bash
sudo yum install -y net-tools
sudo netstat -tulnp | grep httpd
```

Output confirmed:

```
tcp  0  0 0.0.0.0:5004   0.0.0.0:*   LISTEN   1654/httpd
```

---

### 3. Configure Nginx as Load Balancer

Main configuration file: `/etc/nginx/nginx.conf`

Added **upstream block** and **proxy settings**:

```nginx
http {
    upstream app_servers {
        server stapp01:5004;
        server stapp02:5004;
        server stapp03:5004;
    }

    server {
        listen       80;
        server_name  _;
        root         /usr/share/nginx/html;

        location / {
            proxy_pass http://app_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

Reload Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

### 4. Test Load Balancer

From the jump host:

```bash
curl -I http://stlb01
```

Output:

```
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Sun, 21 Sep 2025 17:40:56 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 34
Connection: keep-alive
```

✅ Website successfully served through the load balancer.

---

## Architecture Diagram

```text
              ┌─────────────┐
              │  Jump Host  │
              └──────┬──────┘
                     │ curl http://stlb01
                     ▼
              ┌─────────────┐
              │   LBR Nginx │
              │ (stlb01)    │
              └──────┬──────┘
        ┌────────────┼─────────────┐
        │            │             │
        ▼            ▼             ▼
 ┌────────────┐ ┌────────────┐ ┌────────────┐
 │ stapp01    │ │ stapp02    │ │ stapp03    │
 │ Apache:5004│ │ Apache:5004│ │ Apache:5004│
 └────────────┘ └────────────┘ └────────────┘
```

---

## Conclusion

* **Nginx** was installed and configured on the LBR server.
* Apache on app servers was confirmed to be running on **port 5004**.
* Load balancing with an upstream group (`stapp01`, `stapp02`, `stapp03`) was successfully configured.
* Testing via `curl` confirmed that the application is accessible through the LBR server.

The website is now running on a **high availability stack** with Nginx load balancing. 🎉
