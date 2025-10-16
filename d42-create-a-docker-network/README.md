# Create a custom Docker network for upcoming application deployments

**Server:** App Server 2 (Stratos Datacenter)
**Objective:** Set up a Docker bridge network with a defined subnet and IP range

---

## 🧩 Task Details

| Parameter        | Value          |
| ---------------- | -------------- |
| **Network Name** | `ecommerce`    |
| **Driver**       | `bridge`       |
| **Subnet**       | `10.10.1.0/24` |
| **IP Range**     | `10.10.1.0/24` |

---

## ⚙️ Implementation Steps

### 1. Verified Docker Service on App Server 2

Checked if Docker is active and running:

```bash
sudo systemctl status docker
```

---

### 2. Created the Docker Network

Executed the following command to create the `ecommerce` network:

```bash
sudo docker network create --driver bridge --subnet 10.10.1.0/24 --ip-range 10.10.1.0/24 ecommerce
```

**Output:**

```bash
f0fa85280c1d39ac9a9f70a6e2b92bd4eb0429a83ff769285fcc21e5de62745d
```

---

### 3. Verified Available Networks

Listed all existing Docker networks to confirm creation:

```bash
sudo docker network ls
```

**Output:**

```bash
NETWORK ID     NAME        DRIVER    SCOPE
bb55743dc859   bridge      bridge    local
f0fa85280c1d   ecommerce   bridge    local
03b33c184298   host        host      local
bf8f56a479af   none        null      local
```

---

### 4. Inspected Network Configuration

Checked detailed configuration of the `ecommerce` network:

```bash
sudo docker network inspect ecommerce
```

**Output:**

```json
[
    {
        "Name": "ecommerce",
        "Id": "f0fa85280c1d39ac9a9f70a6e2b92bd4eb0429a83ff769285fcc21e5de62745d",
        "Created": "2025-10-16T12:24:56.450761501Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.10.1.0/24",
                    "IPRange": "10.10.1.0/24"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

---

## ✅ Verification Summary

* Docker network **ecommerce** successfully created.
* **Driver:** bridge
* **Subnet/IP Range:** 10.10.1.0/24
* Verified via `docker network ls` and `docker network inspect`.
* Network ready for container deployment and inter-container communication.

---

**Status:** ✅ *Completed Successfully*
**Network Name:** `ecommerce`
**Server:** App Server 2 (Stratos Datacenter)
**Date Completed:** 2025-10-16

---

