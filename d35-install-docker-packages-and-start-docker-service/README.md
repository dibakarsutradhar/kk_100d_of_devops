# 🐳 Docker Installation Report – App Server 1 (CentOS Stream 9)

## 🧾 Task Summary

> **Objective:**
> Install `docker-ce` and `docker-compose` packages on **App Server 1**, then start the Docker service.

---

## ⚙️ Environment Details

| Item       | Details                                             |
| ---------- | --------------------------------------------------- |
| OS         | CentOS Stream 9                                     |
| User       | `natasha`                                           |
| Host       | `stapp01`                                           |
| Task Scope | Install and verify Docker Engine and Docker Compose |

---

## 🧩 Step 1: Add the Official Docker Repository

```bash
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

✅ *The Docker repository was successfully added to DNF.*

---

## 🐋 Step 2: Install Docker CE and Compose

```bash
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

✅ *Both Docker Engine and Docker Compose plugin were installed successfully.*

---

## 🔥 Step 3: Start and Enable Docker Service

```bash
sudo systemctl enable --now docker
```

✅ *Docker service started successfully and enabled to start on boot.*

You can verify service status:

```bash
sudo systemctl status docker
```

🟢 Expected output:
`Active: active (running)`

---

## 🧪 Step 4: Verify Installation

### Docker Version

```bash
docker --version
```

**Output Example:**

```
Docker version 27.2.0, build e7b65d9
```

### Docker Compose Version

```bash
docker compose version
```

**Output Example:**

```
Docker Compose version v2.27.0
```

---

## 🧱 Step 5: Test Docker Engine

```bash
sudo docker run hello-world
```

✅ *Container runs successfully and displays “Hello from Docker!” message.*

---

## 📸 Screenshots / Evidence

| Description                  | Placeholder                                   |
| ---------------------------- | --------------------------------------------- |
| Docker service running       | `![Docker Service Status](<screenshot_path>)` |
| Docker version output        | `![Docker Version](<screenshot_path>)`        |
| Hello-world container output | `![Docker Hello World](<screenshot_path>)`    |

---

## ✅ Final Verification

| Check                       | Status |
| --------------------------- | ------ |
| Docker CE Installed         | ✅      |
| Docker Compose Installed    | ✅      |
| Docker Service Running      | ✅      |
| Hello-world Test Successful | ✅      |

---

## 🧾 Conclusion

Docker and Docker Compose were successfully installed and configured on **App Server 1 (CentOS Stream 9)**.
The service is enabled and verified functional.

---
