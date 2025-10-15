# Create a custom Docker image for the Nautilus application team

**Server:** App Server 1 (Stratos Datacenter)
**Objective:** Build a Docker image from a Dockerfile as per project requirements

---

## 🧩 Task Details

### Requirements

1. **Base Image:** `ubuntu:24.04`
2. **Install:** `apache2`
3. **Configure Apache** to listen on port **8087**
4. **Do not modify** any other Apache configuration (like document root).

---

## ⚙️ Implementation Steps

### 1. Navigate to Target Directory

```bash
cd /opt/docker/
```

### 2. Create the Dockerfile

```bash
sudo vi Dockerfile
```

### 3. Add the Following Content

```Dockerfile
# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Install Apache2
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# Change Apache port to 8087
RUN sed -i 's/80/8087/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:8087/g' /etc/apache2/sites-enabled/000-default.conf

# Expose the new port
EXPOSE 8087

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
```

### 4. Build the Docker Image

```bash
sudo docker build -t custom_apache:24.04 .
```

### 5. Verify the Image

```bash
sudo docker images | grep custom_apache
```

### 6. (Optional) Test the Container

```bash
sudo docker run -d -p 8087:8087 --name apache_test custom_apache:24.04
curl localhost:8087
```

---

## ✅ Verification

* The image **custom_apache:24.04** was successfully built.
* Apache runs on **port 8087** inside the container.
* Verified with `curl localhost:8087`.

---

**Status:** ✅ *Completed Successfully*
**File Created:** `/opt/docker/Dockerfile`
**Image Tag:** `custom_apache:24.04`

---
