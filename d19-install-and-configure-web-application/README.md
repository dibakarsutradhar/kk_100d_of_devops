# Static Website Hosting Report – App Server 2

## 📝 Task Summary

xFusionCorp Industries required hosting preparation for **two static websites** on **App Server 2**. The objectives were:

1. Install and configure **Apache (httpd)**.
2. Run Apache on **port 8086** (custom port).
3. Deploy two websites (`media` and `demo`) under `/var/www/html/`.
4. Verify accessibility using `curl` on the server.

---

## ⚙️ Steps Performed

### 1. Install and Configure Apache

```bash
sudo yum install -y httpd
sudo vi /etc/httpd/conf/httpd.conf
```

* Changed `Listen 80` → `Listen 8086` to serve Apache on port **8086**.

---

### 2. Deploy Website Files

Moved the site backups into Apache’s document root:

```bash
sudo mv /tmp/media /var/www/html/
sudo mv /tmp/demo /var/www/html/
```

Set correct ownership:

```bash
sudo chown apache:apache /var/www/html/{media,demo}
```

---

### 3. Enable and Restart Apache

```bash
sudo systemctl enable httpd
sudo systemctl restart httpd
```

---

### 4. Verification

Tested the setup locally on App Server 2:

```bash
curl http://localhost:8086/media/
```

Output:

```html
<!DOCTYPE html>
<html>
<body>
<h1>KodeKloud</h1>
<p>This is a sample page for our media website</p>
</body>
</html>
```

```bash
curl http://localhost:8086/demo/
```

Output:

```html
<!DOCTYPE html>
<html>
<body>
<h1>KodeKloud</h1>
<p>This is a sample page for our demo website</p>
</body>
</html>
```

---

## ✅ Results

* Apache is running successfully on **port 8086**.
* Both websites (`media` and `demo`) are accessible via:

  * `http://localhost:8086/media/`
  * `http://localhost:8086/demo/`
* Website ownership and permissions are correctly assigned to the `apache` user.

---

## 📌 Conclusion

The task was completed successfully. App Server 2 is now serving two static websites under Apache on **port 8086**, meeting all the requirements.
