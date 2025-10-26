# 🧾 Kubernetes Rollback Report — `nginx-deployment`

## 🧩 Task Description

The Nautilus DevOps team recently deployed a new version of the **nginx** application that introduced a bug.
To restore stability, the task was to **rollback the deployment `nginx-deployment` to its previous revision**.

---

## ⚙️ Environment

* **Cluster Access:** via `kubectl` on `jump_host`
* **Deployment Name:** `nginx-deployment`
* **Namespace:** `default`

---

## 🧠 Step-by-Step Execution

### 1️⃣ Check Existing Deployments

```bash
thor@jumphost ~$ kubectl get deployments
```

**Output:**

```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           46s
```

✅ Confirms the deployment `nginx-deployment` is active.

---

### 2️⃣ Review Rollout History

```bash
thor@jumphost ~$ kubectl rollout history deployment/nginx-deployment 
```

**Output:**

```
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment nginx-deployment nginx-container=nginx:stable --kubeconfig=/root/.kube/config --record=true
```

✅ Confirms there are **two revisions**, and revision 2 used `nginx:stable`.

---

### 3️⃣ Perform Rollback

```bash
thor@jumphost ~$ kubectl rollout undo deployment/nginx-deployment 
```

**Output:**

```
deployment.apps/nginx-deployment rolled back
```

✅ Rollback successfully initiated.

---

### 4️⃣ Verify Rollout Completion

```bash
thor@jumphost ~$ kubectl rollout status deployment/nginx-deployment 
```

**Output:**

```
deployment "nginx-deployment" successfully rolled out
```

✅ Deployment rollback completed and is stable.

---

### 5️⃣ Confirm Image Version Post-Rollback

```bash
thor@jumphost ~$ kubectl describe deployment nginx-deployment | grep -i image
```

**Output:**

```
    Image:         nginx:1.16
```

✅ Confirms rollback restored the **previous image version (`nginx:1.16`)**.

---

## 🧾 Summary

| Step                 | Command                       | Result                     |
| -------------------- | ----------------------------- | -------------------------- |
| Check deployment     | `kubectl get deployments`     | ✅ Deployment active        |
| View history         | `kubectl rollout history ...` | ✅ Found revisions 1 & 2    |
| Rollback             | `kubectl rollout undo ...`    | ✅ Rolled back successfully |
| Check rollout status | `kubectl rollout status ...`  | ✅ Deployment stable        |
| Verify image         | `kubectl describe ...`        | ✅ Restored to `nginx:1.16` |

---

## ✅ Final Status

The **rollback operation** for `nginx-deployment` completed successfully.
All pods are running the **previous stable version (nginx:1.16)** and the deployment is fully available.

---
