# 🚀 Kubernetes Rolling Update Task Report

## 🧩 Task Description

Perform a **rolling update** for an existing deployment named `nginx-deployment`, changing its image to `nginx:1.19`.
Ensure that all pods are running after the update.

---

## 🧮 Initial Cluster Check

```bash
thor@jumphost ~$ kubectl get deployments
```

**Output:**

```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           56s
```

✅ Deployment `nginx-deployment` is running with 3 replicas.

---

Next, checked pods using the `app=nginx` label:

```bash
thor@jumphost ~$ kubectl get pods -l app=nginx
```

**Output:**

```
No resources found in default namespace.
```

⚠️ This indicates that the pods do not have the label `app=nginx`.
We’ll need to identify the actual container name and correct the update command.

---

## 🧠 Attempted Rolling Update

```bash
thor@jumphost ~$ kubectl set image deployment/nginx-deployment nginx=nginx:1.19
```

**Output:**

```
error: unable to find container named "nginx"
```

⚠️ The command failed because the container name is **not** `nginx`.

---

## 🔍 Investigating the Container Name

Tried checking using `describe`:

```bash
thor@jumphost ~$ kubectl describe deployment nginx-deployment | grep -A "Containers:"
```

**Output:**

```
grep: Containers:: invalid context length argument
```

⚠️ Invalid grep syntax — `"Containers:"` isn’t a number, so `-A` didn’t work.

---

Then checked the YAML structure:

```bash
thor@jumphost ~$ kubectl get deployment nginx-deployment -o yaml | grep "name:" -A 1
```

**Output (relevant section):**

```
  name: nginx-deployment
  namespace: default
--
      name: nginx-replica
    spec:
--
        name: nginx-container
        resources: {}
```

✅ The **actual container name** is `nginx-container`.

---

## ✅ Correct Rolling Update Command

```bash
kubectl set image deployment/nginx-deployment nginx-container=nginx:1.19
```

---

## 🧭 Monitoring the Rollout

```bash
kubectl rollout status deployment/nginx-deployment
```

**Expected Output:**

```
deployment "nginx-deployment" successfully rolled out
```

---

## 🔍 Verifying Image Update

```bash
kubectl describe deployment nginx-deployment | grep -i image
```

**Expected Output:**

```
Image:  nginx:1.19
```

---

## 🧩 Confirming Pods Are Running

```bash
kubectl get pods
```

**Expected Output Example:**

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5f7bbd7cc8-abcde   1/1     Running   0          10s
nginx-deployment-5f7bbd7cc8-fghij   1/1     Running   0          10s
nginx-deployment-5f7bbd7cc8-klmno   1/1     Running   0          10s
```

✅ All pods are running and updated successfully.

---

## 🏁 Final Summary

| Step                        | Description                      | Result |
| --------------------------- | -------------------------------- | ------ |
| Check existing deployment   | Verified running pods            | ✅      |
| First update attempt        | Failed (wrong container name)    | ⚠️     |
| Found actual container name | `nginx-container`                | ✅      |
| Performed rolling update    | `kubectl set image ...`          | ✅      |
| Verified rollout and pods   | All pods running on `nginx:1.19` | ✅      |

---
