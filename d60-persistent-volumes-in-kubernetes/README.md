# Kubernetes Deployment Report: Datacenter Web Application

## 1. Overview

This task involved deploying a simple web application (Apache HTTP server) on a Kubernetes cluster with persistent storage. The setup ensures that the web content persists using a **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)**, and the application is exposed externally using a **NodePort Service**.

---

## 2. Kubernetes Objects Created

| Kind                        | Name             | Status  | Details                                                                                         |
| --------------------------- | ---------------- | ------- | ----------------------------------------------------------------------------------------------- |
| PersistentVolume (PV)       | `pv-datacenter`  | Bound   | 4Gi storage, `ReadWriteOnce`, `hostPath` `/mnt/finance`, storageClass `manual`                  |
| PersistentVolumeClaim (PVC) | `pvc-datacenter` | Bound   | Request 1Gi storage, uses PV `pv-datacenter`, access mode `ReadWriteOnce`                       |
| Pod                         | `pod-datacenter` | Running | Single container (`container-datacenter`) running `httpd:latest`, mounts PVC at `/var/www/html` |
| Service                     | `web-datacenter` | Active  | NodePort service on port 80, nodePort 30008, exposes pod externally                             |

---

## 3. YAML Configuration Summary

### 3.1 PersistentVolume (PV)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-datacenter
spec:
  storageClassName: manual
  capacity:
    storage: 4Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/finance
    type: ""
```

### 3.2 PersistentVolumeClaim (PVC)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-datacenter
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### 3.3 Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-datacenter
  labels: 
    app: datacenter
spec:
  containers:
    - name: container-datacenter
      image: httpd:latest
      volumeMounts:
        - name: finance
          mountPath: /var/www/html
  volumes:
    - name: finance
      persistentVolumeClaim:
        claimName: pvc-datacenter
```

### 3.4 Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-datacenter
spec:
  type: NodePort
  selector:
    app: datacenter
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 30008
```

---

## 4. Deployment Status

### Pods

```bash
kubectl get pods
NAME                 READY   STATUS    RESTARTS   AGE
pod-datacenter       1/1     Running   0          2m
```

### PV and PVC

```bash
kubectl get pv,pvc
NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS
pv-datacenter   4Gi        RWO            Retain           Bound    default/pvc-datacenter   manual

NAME             STATUS   VOLUME          CAPACITY   ACCESS MODES   STORAGECLASS
pvc-datacenter   Bound    pv-datacenter   4Gi        RWO            manual
```

### Service

```bash
kubectl get svc web-datacenter
NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
web-datacenter     NodePort   10.96.xxx.xxx   <none>        80:30008/TCP   2m
```

---

## 5. Testing & Observations

1. The pod is running and Apache HTTP server is active.
2. PersistentVolumeClaim is **Bound** to the PersistentVolume.
3. NodePort service exposes the pod on port `30008`.
4. Logs confirm Apache started successfully:

```
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.244.0.5.
[mpm_event:notice] Apache/2.4.65 configured -- resuming normal operations
```

5. Issue noted: If the mounted PV is empty, visiting the service may result in a **502 Bad Gateway** or blank page. To fix, add a simple `index.html` into the volume:

```bash
kubectl exec -it pod-datacenter -- sh -c 'echo "<h1>Welcome to Datacenter App!</h1>" > /var/www/html/index.html'
```

---

## 6. Conclusion

The deployment is now functional:

* Pod is running with persistent storage.
* NodePort service exposes the web server externally.
* PV/PVC configuration ensures data persists across pod restarts.
* Web content needs to be populated in `/var/www/html` for Apache to serve pages correctly.

---
