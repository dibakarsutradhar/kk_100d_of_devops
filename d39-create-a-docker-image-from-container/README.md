# Create Docker Image from Running Container
**Server:** Application Server 3
**OS:** CentOS 9

---

## 📋 Task Description

A Nautilus developer has made changes inside a running container and wants to preserve those changes as a reusable Docker image.
The DevOps team has been tasked to create a new image based on this container.

### **Requirements**

* Target Server: **Application Server 3**
* Container Name: **`ubuntu_latest`** (currently running)
* New Image Name: **`blog:datacenter`**

---

## ⚙️ Implementation Steps

### **1. Switch to Application Server 3**

```bash
ssh tony@stapp03
```

---

### **2. Verify Docker Service and Running Containers**

Ensure Docker is running:

```bash
sudo systemctl status docker
```

List running containers:

```bash
sudo docker ps
```

Expected output:

```
CONTAINER ID   IMAGE           COMMAND       STATUS         NAMES
abcd1234ef56   ubuntu:latest   "/bin/bash"   Up 3 hours     ubuntu_latest
```

Confirm the container **`ubuntu_latest`** is active.

---

### **3. Commit the Container as a New Image**

Use the `docker commit` command to create a new image:

```bash
sudo docker commit ubuntu_latest blog:datacenter
```

**Explanation:**

* `ubuntu_latest` → source container name
* `blog:datacenter` → new image name and tag

---

### **4. Verify Image Creation**

List local images:

```bash
sudo docker images
```

Expected output:

```
REPOSITORY   TAG          IMAGE ID       CREATED          SIZE
blog         datacenter   123abc456def   10 seconds ago   120MB
ubuntu       latest       789ghi101jkl   2 days ago       120MB
```

✅ The new image `blog:datacenter` should appear with a recent creation timestamp.

---

### **5. (Optional) Test the New Image**

Run a test container to verify the image:

```bash
sudo docker run -it --rm blog:datacenter bash
```

If it runs successfully, the backup image is functional.

---

## ✅ Verification & Result

| Checkpoint              | Command                        | Result                    |
| ----------------------- | ------------------------------ | ------------------------- |
| Docker running          | `sudo systemctl status docker` | ✔ Active                  |
| Source container active | `sudo docker ps`               | ✔ ubuntu_latest running   |
| New image created       | `sudo docker commit`           | ✔ blog:datacenter created |
| Verified in local repo  | `sudo docker images`           | ✔ Listed                  |
| Tested new image        | `sudo docker run`              | ✔ Runs successfully       |

---

## 📦 Conclusion

The new Docker image **`blog:datacenter`** was successfully created from the running container **`ubuntu_latest`** on **Application Server 3**.
This image securely preserves all container changes and can be reused for further testing or deployment.

---
