# Deploy an Nginx container for hosting applications

**Server:** App Server 2 (Stratos Datacenter)
**Objective:** Pull the official Nginx image and run a container mapped to a custom host port

---

## 🧩 Task Details

| Parameter          | Value                   |
| ------------------ | ----------------------- |
| **Image**          | `nginx:stable`          |
| **Container Name** | `official`              |
| **Host Port**      | `8083`                  |
| **Container Port** | `80`                    |
| **Status**         | Must remain **running** |

---

## ⚙️ Implementation Steps

### 1. Pull the Nginx Image

```bash
sudo docker pull nginx:stable
```

**Output:**

```bash
stable: Pulling from library/nginx
Digest: sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Status: Downloaded newer image for nginx:stable
docker.io/library/nginx:stable
```

---

### 2. Verify Image Download

```bash
sudo docker images | grep nginx
```

Expected output:

```
nginx      stable     <image_id>     <date>     <size>
```

---

### 3. Create and Run the Container

Run the Nginx container with proper port mapping:

```bash
sudo docker run -d --name official -p 8083:80 nginx:stable
```

**Explanation:**

* `-d` → Detached mode
* `--name official` → Assigns container name
* `-p 8083:80` → Maps host port 8083 to container port 80

---

### 4. Verify Container Status

```bash
sudo docker ps
```

**Expected Output:**

```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
xxxxxxxxxxxx   nginx:stable   "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds    0.0.0.0:8083->80/tcp   official
```

---

### 5. Test Connectivity

```bash
curl localhost:8083
```

✅ You should see the default Nginx welcome page HTML content:

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
</html>
```

---

## 🧾 Bash History (Chronological)

```bash
[steve@stapp02 ~]$ sudo docker pull nginx:stable
stable: Pulling from library/nginx
Digest: sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Status: Downloaded newer image for nginx:stable
docker.io/library/nginx:stable

[steve@stapp02 ~]$ sudo docker run -d --name official -p 8083:80 nginx:stable
abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx1234yzab5678cdef9012

[steve@stapp02 ~]$ sudo docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
abcd1234efgh   nginx:stable   "/docker-entrypoint.…"   12 seconds ago   Up 11 seconds   0.0.0.0:8083->80/tcp   official

[steve@stapp02 ~]$ curl localhost:8083
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
</html>
```

---

## ✅ Verification Summary

* **Image pulled:** `nginx:stable`
* **Container name:** `official`
* **Port mapping:** Host `8083` → Container `80`
* **Container state:** Running
* **Connectivity check:** Successful (Nginx default page returned)

---

**Status:** ✅ *Completed Successfully*
**Container:** `official`
**Image:** `nginx:stable`
**Host Port:** 8083
**Location:** App Server 2 (Stratos DC)
**Date Completed:** 2025-10-16

---
