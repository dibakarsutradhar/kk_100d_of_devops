# 🧩 Kubernetes Resource Limits Configuration – httpd Pod

## 📘 Task Summary
The task required creating a Kubernetes pod to host an `httpd` application while enforcing CPU and memory resource requests and limits.

---

## 🏗️ Configuration Details
- **Pod Name:** `httpd-pod`
- **Container Name:** `httpd-container`
- **Image:** `httpd:latest`
- **Resource Requests:**
  - Memory: `15Mi`
  - CPU: `100m`
- **Resource Limits:**
  - Memory: `20Mi`
  - CPU: `100m`

---

## ⚙️ Commands Executed
```bash
vi httpd-pod.yaml
kubectl apply -f httpd-pod.yaml
kubectl get pods
kubectl describe pod httpd-pod
```

---

## 📋 Verification Output

```bash
NAME        READY   STATUS    RESTARTS   AGE
httpd-pod   1/1     Running   0          20s
```

**Resource Configuration Verified:**

```bash
Limits:
  cpu:     100m
  memory:  20Mi
Requests:
  cpu:     100m
  memory:  15Mi
QoS Class: Burstable
```

---

## ✅ Final Status

| Checkpoint         | Result      |
| ------------------ | ----------- |
| Pod Created        | ✅ Success   |
| Container Running  | ✅ Success   |
| Resource Requests  | ✅ Verified  |
| Resource Limits    | ✅ Verified  |
| QoS Classification | ✅ Burstable |

---

### ✔️ Conclusion

The `httpd-pod` was successfully deployed with defined CPU and memory resource constraints.
All configuration checks passed and the pod is running smoothly in the cluster.
