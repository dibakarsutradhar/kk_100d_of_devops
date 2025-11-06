# Kubernetes Secret Deployment Report

## Objective

Securely store and consume sensitive license or password information using **Kubernetes Secrets**, ensuring it is safely mounted within a running pod.

---

## Task Summary

| Component      | Name                      | Purpose                                               |
| -------------- | ------------------------- | ----------------------------------------------------- |
| **Secret**     | `news`                    | Stores license/password securely from `/opt/news.txt` |
| **Pod**        | `secret-devops`           | Runs a Fedora container that reads the mounted secret |
| **Container**  | `secret-container-devops` | Executes `sleep` to keep container running            |
| **Mount Path** | `/opt/apps`               | Location where the secret file is mounted             |

---

## Implementation Details

### 1. Secret Creation

Created a generic secret from the host file `/opt/news.txt`:

```bash
kubectl create secret generic news --from-file=/opt/news.txt
```

**Verification Output:**

```
kubectl get secrets
NAME   TYPE     DATA   AGE
news   Opaque   1      8s
```

**Description:**

```
kubectl describe secret news
Name:         news
Type:         Opaque
Data:
news.txt:     7 bytes
```

---

### 2. Pod Configuration

**YAML File: `secret-devops.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-devops
spec:
  containers:
    - name: secret-container-devops
      image: fedora:latest
      command: ["/bin/bash", "-c", "sleep 3600"]
      volumeMounts:
        - name: secret-volume
          mountPath: /opt/apps
  volumes:
    - name: secret-volume
      secret:
        secretName: news
```

**Applied:**

```bash
kubectl apply -f secret-devops.yaml
```

**Status:**

```
kubectl get pods
NAME            READY   STATUS    RESTARTS   AGE
secret-devops   1/1     Running   0          9s
```

---

### 3. Validation of Secret Mount

Accessed the running pod:

```bash
kubectl exec -it secret-devops -- /bin/bash
```

Checked mounted secret:

```
ls -l /opt/apps/
total 0
lrwxrwxrwx 1 root root 15 Nov  6 16:57 news.txt -> ..data/news.txt
```

Read the secret file:

```
cat /opt/apps/news.txt
5ecur3
```

✅ Secret file successfully mounted and accessible inside the container.

---

## Final Verification Summary

| Step                                  | Status |
| ------------------------------------- | ------ |
| Secret created from file              | ✅      |
| Pod deployed successfully             | ✅      |
| Secret mounted at `/opt/apps`         | ✅      |
| Secret readable from inside container | ✅      |

---

## Key Insights

* Kubernetes **Secrets** are ideal for storing sensitive configuration data.
* Mounting secrets as **volumes** ensures no plaintext credentials in pod specs.
* Using symlinks (`..data/news.txt`) allows Kubernetes to automatically update secrets if rotated.
* Access control can be managed using RBAC and namespaces for isolation.

---
