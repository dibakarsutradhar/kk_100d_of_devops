# Kubernetes Sidecar Containers

---

## **Step-by-Step Implementation**

### 1. **Create the Pod manifest**

Open a new file:

```bash
vi webserver.yaml
```

### 2. **Add the following YAML manifest:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}
  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

    - name: sidecar-container
      image: ubuntu:latest
      command: ["sh", "-c", "while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

---

### 3. **Apply the manifest**

```bash
kubectl apply -f webserver.yaml
```

---

### 4. **Verify Pod and containers**

```bash
kubectl get pods
```

Expected output:

```
NAME         READY   STATUS    RESTARTS   AGE
webserver    2/2     Running   0          10s
```

To confirm both containers are running:

```bash
kubectl describe pod webserver | grep -A2 "Containers:"
```

---

### 5. **Validate shared volume**

You can check the sidecar logs to confirm it’s tailing Nginx logs:

```bash
kubectl logs webserver -c sidecar-container
```

You should see continuous output of:

```
127.0.0.1 - - [timestamp] "GET / HTTP/1.1" 200 ...
```

---

## ✅ **Validation Checklist**

| Requirement                                        | Status |
| -------------------------------------------------- | ------ |
| Pod name: `webserver`                              | ✅      |
| Containers: `nginx-container`, `sidecar-container` | ✅      |
| Images: `nginx:latest`, `ubuntu:latest`            | ✅      |
| Shared volume: `shared-logs` of type `emptyDir`    | ✅      |
| Mounted at `/var/log/nginx` in both containers     | ✅      |
| Sidecar running log-shipping command               | ✅      |
| Pod status: Running (2/2)                          | ✅      |

---
