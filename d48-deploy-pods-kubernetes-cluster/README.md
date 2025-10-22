# Deploy `pod-httpd` in Kubernetes

### 🧠 Task Objective

Create and deploy a Kubernetes Pod using the **httpd:latest** image with specific configuration details.

---

## 📋 Task Requirements

| Parameter          | Specification                                            |
| ------------------ | -------------------------------------------------------- |
| **Pod Name**       | `pod-httpd`                                              |
| **Container Name** | `httpd-container`                                        |
| **Image**          | `httpd:latest`                                           |
| **Label**          | `app=httpd_app`                                          |
| **Tool Used**      | `kubectl`                                                |
| **Environment**    | Stratos DC — Kubernetes Cluster (access via `jump_host`) |

---

## ⚙️ Implementation Steps

### 1️⃣ Create the Pod Manifest

Created file:
`pod-httpd.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-httpd
  labels:
    app: httpd_app
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
```

---

### 2️⃣ Apply the Manifest

```bash
kubectl apply -f pod-httpd.yaml
```

**Output:**

```
pod/pod-httpd created
```

---

### 3️⃣ Verify Pod Creation

```bash
kubectl get pods
```

**Output:**

```
NAME        READY   STATUS    RESTARTS   AGE
pod-httpd   1/1     Running   0          10s
```

---

### 4️⃣ Inspect Pod Details

```bash
kubectl describe pod pod-httpd
```

**Key details:**

```
Name:             pod-httpd
Namespace:        default
Labels:           app=httpd_app
Container Name:   httpd-container
Image:            httpd:latest
State:            Running
IP:               10.244.0.5
Node:             kodekloud-control-plane/172.17.0.2
```

**Events:**

```
Normal  Scheduled  Successfully assigned default/pod-httpd
Normal  Pulling    Pulling image "httpd:latest"
Normal  Pulled     Successfully pulled image "httpd:latest"
Normal  Created    Created container httpd-container
Normal  Started    Started container httpd-container
```

---

## ✅ Verification Summary

| Component          | Expected          | Actual            | Status |
| ------------------ | ----------------- | ----------------- | ------ |
| **Pod Name**       | `pod-httpd`       | `pod-httpd`       | ✅      |
| **Container Name** | `httpd-container` | `httpd-container` | ✅      |
| **Image Used**     | `httpd:latest`    | `httpd:latest`    | ✅      |
| **Label**          | `app=httpd_app`   | `app=httpd_app`   | ✅      |
| **Pod Status**     | Running           | Running           | ✅      |

---

## 🏁 Final Outcome

The Kubernetes Pod **`pod-httpd`** was successfully created, deployed, and verified to be in a **Running** state with the correct configuration.

---
