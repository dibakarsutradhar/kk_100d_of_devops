# Nautilus PHP Application Deployment Report

**Prepared by:** Production Support Team
**Date:** 25th September 2025
**Environment:** Stratos Datacenter, Nautilus Infra

## Objective

Deploy a new PHP-based application on **App Server 1 (stapp01)** using **nginx** and **PHP-FPM 8.1**, and configure the application to serve PHP pages via a UNIX socket.

The application files `index.php` and `info.php` are already copied under `/var/www/html`. No modification of these files is required.

---

## Tasks Performed

### 1. Install nginx

* Installed nginx package using:

```bash
sudo yum install -y nginx
```

* Enabled and started the service:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```

* Configured nginx to serve on port **8096**. Edited `/etc/nginx/nginx.conf` (or a custom site config):

```nginx
server {
    listen 8096;
    server_name stapp01;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/default.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

* Tested nginx configuration:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

### 2. Install PHP-FPM 8.1

* Installed PHP-FPM and required modules:

```bash
sudo yum install -y php-fpm php-cli php-mysqlnd
```

* Configured PHP-FPM to use UNIX socket `/var/run/php-fpm/default.sock` by editing `/etc/php-fpm.d/www.conf`:

```ini
listen = /var/run/php-fpm/default.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
listen.allowed_clients = 127.0.0.1
```

* Ensured parent directory exists and correct ownership:

```bash
sudo mkdir -p /var/run/php-fpm
sudo chown nginx:nginx /var/run/php-fpm
```

* Restarted PHP-FPM:

```bash
sudo systemctl enable php-fpm
sudo systemctl restart php-fpm
```

---

### 3. Configure PHP-FPM and nginx

* Verified that nginx fastcgi_pass points to `/var/run/php-fpm/default.sock`.
* Ensured `index.php` and `info.php` are under `/var/www/html`.
* Verified file permissions: readable by `nginx` user:

```bash
sudo chown -R nginx:nginx /var/www/html
```

---

### 4. Verification

* Tested application from jump host using curl:

```bash
curl http://stapp01:8096/index.php
```

**Expected output:** Content of `index.php` displayed correctly.

* Also tested `info.php`:

```bash
curl http://stapp01:8096/info.php
```

**Expected output:** PHP info page displayed, confirming PHP-FPM is working with nginx.

---

## Observations

* PHP-FPM socket configuration required changing the default pool socket from `/run/php-fpm/www.sock` to `/var/run/php-fpm/default.sock`.
* Proper ownership and permissions were essential for nginx to communicate with PHP-FPM.
* Manual verification using `curl` confirmed the setup was functional.

---

## Conclusion

* nginx is serving the PHP application on port **8096**.
* PHP-FPM 8.1 is correctly configured to work with nginx via UNIX socket.
* The PHP application (`index.php` and `info.php`) is fully accessible and operational.
