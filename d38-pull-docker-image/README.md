# Pull and Retag Docker Image
**Server:** Application Server 1
**OS:** CentOS 9

---

## 📋 Task Description

The Nautilus project developers are preparing to test new features in a containerized environment.
They have requested the DevOps team to set up the required Docker image for testing.

### **Requirements**

* Connect to **App Server 1** in the Stratos Datacenter
* Pull the image **`busybox:musl`** from Docker Hub
* Re-tag (create a new tag) as **`busybox:media`**

---

## ⚙️ Implementation Steps

### **1. Switch to Application Server 1**

```bash
ssh tony@stapp01
```

---

### **2. Verify Docker Installation**

Check Docker status:

```bash
sudo systemctl status docker
```

If Docker is not installed, install and start it:

```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

---

### **3. Pull the Required Image**

Pull the **busybox:musl** image from Docker Hub:

```bash
sudo docker pull busybox:musl
```

Verify it’s downloaded:

```bash
sudo docker images
```

Expected output:

```
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
busybox      musl    <image_id>     <date>        <size>
```

---

### **4. Re-tag the Image**

Create a new tag `busybox:media`:

```bash
sudo docker tag busybox:musl busybox:media
```

---

### **5. Verify the New Tag**

List all local Docker images:

```bash
sudo docker images
```

Expected output:

```
REPOSITORY   TAG     IMAGE ID       CREATED       SIZE
busybox      musl    abc123def456   2 days ago    1.4MB
busybox      media   abc123def456   2 days ago    1.4MB
```

✅ Note: Both tags share the **same IMAGE ID**, confirming the re-tag was successful.

---

## ✅ Verification & Result

| Checkpoint         | Command                                      | Result          |
| ------------------ | -------------------------------------------- | --------------- |
| Docker running     | `sudo systemctl status docker`               | ✔ Active        |
| Image pulled       | `sudo docker pull busybox:musl`              | ✔ Completed     |
| Image re-tagged    | `sudo docker tag busybox:musl busybox:media` | ✔ Done          |
| Both tags verified | `sudo docker images`                         | ✔ Same IMAGE ID |

---

## 📦 Conclusion

The **busybox:musl** image was successfully pulled on **App Server 1**,
and re-tagged as **busybox:media**.
All task requirements were completed and verified successfully.

---
