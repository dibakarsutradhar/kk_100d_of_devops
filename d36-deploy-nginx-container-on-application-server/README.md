# Nginx Container Deployment on Application Server 3
**Author:** Banner

---

## 📋 Task Description

The Nautilus DevOps team is conducting application deployment tests on selected application servers.
They require an **Nginx container deployment** on **Application Server 3** using the **alpine** image variant.

### **Requirements**

* Create a container named `nginx_3`
* Use the image `nginx:alpine`
* Ensure the container is in a **running** state

---

## ⚙️ Implementation Steps

### **1. Switch to Application Server 3**

```bash
ssh banner@stapp03
```

---

### **2. Verify or Install Docker**

Check if Docker is installed and running:

```bash
sudo systemctl status docker
```

If not installed, execute:

```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

Confirm Docker is active:

```bash
sudo docker ps
```

---

### **3. Pull the Required Nginx Image**

```bash
sudo docker pull nginx:alpine
```

This downloads the lightweight Nginx image based on Alpine Linux.

---

### **4. Create and Run the Container**

```bash
sudo docker run -d --name nginx_3 nginx:alpine
```

**Options used:**

* `-d`: Run container in detached mode
* `--name nginx_3`: Assigns the container name
* `nginx:alpine`: Specifies the image to use

---

### **5. Verify the Container Status**

```bash
sudo docker ps
```

**Expected Output:**

```
CONTAINER ID   IMAGE          COMMAND                  STATUS         PORTS   NAMES
abc123def456   nginx:alpine   "/docker-entrypoint.…"   Up 10 seconds          nginx_3
```

The container `nginx_3` should appear in the list with the **STATUS** as **Up**.

---

## ✅ Verification & Result

| Checkpoint        | Command              | Result                   |
| ----------------- | -------------------- | ------------------------ |
| Docker installed  | `sudo docker ps`     | ✔ Running                |
| Image pulled      | `sudo docker images` | ✔ nginx:alpine available |
| Container created | `sudo docker ps`     | ✔ nginx_3 listed         |
| Container running | `sudo docker ps`     | ✔ STATUS = Up            |

---

## 📦 Conclusion

The **nginx_3** container was successfully created and is running on **Application Server 3** using the **nginx:alpine** image.
All task requirements have been met and verified.

---
