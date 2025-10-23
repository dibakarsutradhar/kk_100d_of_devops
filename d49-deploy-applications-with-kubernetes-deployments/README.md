# 🧾 Kubernetes Deployment Report – nginx

## 🧩 Task Summary

The Nautilus DevOps team needed to create a **Kubernetes deployment** named `nginx` to deploy an application using the image `nginx:latest`.  
The `kubectl` utility on the `jump_host` was already configured to interact with the cluster.

---

## ⚙️ Commands Executed

```bash
# Check cluster node status
kubectl get nodes

# Create deployment using nginx:latest image
kubectl create deployment nginx --image=nginx:latest

# Verify deployment creation
kubectl get deployments

# Verify associated pods
kubectl get pods -l app=nginx

# Describe deployment for detailed configuration
kubectl describe deployment nginx
```

---

## 📋 Command Output

### 1️⃣ Cluster Nodes

```bash
NAME                      STATUS   ROLES           AGE   VERSION
kodekloud-control-plane   Ready    control-plane   10m   v1.27.16-1+f5da3b717fc217
```

---

### 2️⃣ Deployment Creation

```bash
deployment.apps/nginx created
```

---

### 3️⃣ Deployment Status

```bash
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           13s
```

---

### 4️⃣ Pods Running

```bash
NAME                     READY   STATUS    RESTARTS   AGE
nginx-7bf8c77b5b-g6td7   1/1     Running   0          31s
```

---

### 5️⃣ Deployment Description

```bash
Name:                   nginx
Namespace:              default
CreationTimestamp:      Thu, 23 Oct 2025 14:46:18 +0000
Labels:                 app=nginx
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
Container:
  Name:  nginx
  Image: nginx:latest
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  48s   deployment-controller  Scaled up replica set nginx-7bf8c77b5b to 1
```

---

## ✅ Final Verification

* Deployment **`nginx`** created successfully.
* Image used: **`nginx:latest`**
* Replica: **1/1 running**
* Pod labeled with **`app=nginx`**
* Cluster node: **kodekloud-control-plane**

---

**✔️ Final Status:**
✅ Deployment successfully created and verified.

---
