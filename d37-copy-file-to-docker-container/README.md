# 🔐 KodeKloud DevOps Task Report

**Task Name:** Copy Encrypted File to Container
**OS:** CentOS 9
**Server:** Application Server 3

---

## 📋 Task Description

The Nautilus DevOps team possesses confidential data on **App Server 3** within the **Stratos Datacenter**.
A container named **`ubuntu_latest`** is already running on this server.

The goal is to **securely copy an encrypted file** from the **Docker host** to the **container**.

### **Requirements**

* Source file: `/tmp/nautilus.txt.gpg` (on Docker host)
* Destination path inside container: `/opt/`
* Container name: `ubuntu_latest`
* The file must **not be modified** during transfer.

---

## ⚙️ Implementation Steps

### **1. Switch to Application Server 3**

```bash
ssh tony@stapp03
```

---

### **2. Verify the Running Container**

List active containers:

```bash
sudo docker ps
```

Expected output:

```
CONTAINER ID   IMAGE      COMMAND       STATUS         NAMES
abcd1234ef56   ubuntu:latest   "/bin/bash"   Up 2 hours     ubuntu_latest
```

---

### **3. Verify the Source File Exists**

```bash
ls -l /tmp/nautilus.txt.gpg
```

Expected output (example):

```
-rw-r--r-- 1 root root 1024 Oct 10 10:22 /tmp/nautilus.txt.gpg
```

---

### **4. Copy the File into the Container**

Use the `docker cp` command to copy the file without altering its contents:

```bash
sudo docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/opt/
```

This command transfers the file **as-is** (preserving content and binary integrity).

---

### **5. Verify the Copy Inside the Container**

Access the container’s shell:

```bash
sudo docker exec -it ubuntu_latest bash
```

Check the destination:

```bash
ls -l /opt/nautilus.txt.gpg
```

Expected output:

```
-rw-r--r-- 1 root root 1024 Oct 10 10:22 /opt/nautilus.txt.gpg
```

Confirm the file matches the host copy (optional integrity check):

```bash
exit
sudo md5sum /tmp/nautilus.txt.gpg
sudo docker exec ubuntu_latest md5sum /opt/nautilus.txt.gpg
```

Both checksums should be identical ✅

---

## ✅ Verification & Result

| Checkpoint                     | Command                    | Result                 |
| ------------------------------ | -------------------------- | ---------------------- |
| Container running              | `sudo docker ps`           | ✔ ubuntu_latest active |
| File exists on host            | `ls /tmp/nautilus.txt.gpg` | ✔ Found                |
| File copied successfully       | `sudo docker cp`           | ✔ Done                 |
| File verified inside container | `ls /opt/`                 | ✔ Present              |
| File integrity check           | `md5sum`                   | ✔ Matches              |

---

## 📦 Conclusion

The encrypted file **`/tmp/nautilus.txt.gpg`** was successfully copied from the **Docker host** to the **`ubuntu_latest`** container at **`/opt/`**.
The file integrity was preserved, fulfilling all Nautilus DevOps team requirements.

---
