# Nginx Deployment & NodePort Service in Kubernetes

## **Objective**

Deploy a **highly available NGINX application** on Kubernetes using a **Deployment** with 3 replicas and expose it via a **NodePort Service (port 30011)**.

---

##️ **Implementation Steps**

### 1️⃣ **Create the Deployment**

File: `nginx-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80
```

Applied successfully:

```bash
kubectl apply -f nginx-deploment.yaml
deployment.apps/nginx-deployment created
```

Verification:

```bash
kubectl get deployments
```

Output:

```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           11s
```

Pods:

```bash
kubectl get pods
```

Output:

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5b58668cfc-2nh7g   1/1     Running   0          15s
nginx-deployment-5b58668cfc-lx5hb   1/1     Running   0          15s
nginx-deployment-5b58668cfc-wc5cx   1/1     Running   0          15s
```

✅ **All 3 replicas are running successfully.**

---

### **Create the NodePort Service**

File: `nginx-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30011
```

First attempt:

```bash
kubectl apply -f nginx-service.yaml
```

❌ Error:

```
The Service "nginx-service" is invalid: spec.type: Unsupported value: "Nodeport": supported values: "ClusterIP", "ExternalName", "LoadBalancer", "NodePort"
```

**Fix:** Corrected the capitalization — `NodePort` (uppercase “P”).

Reapplied:

```bash
kubectl apply -f nginx-service.yaml
service/nginx-service created
```

Verification:

```bash
kubectl get svc nginx-service
```

Output:

```
NAME            TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
nginx-service   NodePort   10.96.45.161   <none>        80:30011/TCP   8s
```

---

### **Check Node Access**

```bash
kubectl get nodes -o wide
```

Output:

```
NAME                      STATUS   ROLES           AGE   VERSION                     INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane   17m   v1.27.16-1+f5da3b717fc217   172.17.0.2    <none>        Ubuntu 23.10   5.4.0-1106-gcp   containerd://1.7.1-2-g8f682ed69
```

Access via browser or curl:

```
http://172.17.0.2:30011
```

You’ll see the **default NGINX welcome page**.

---

### ✅ **Verification Checklist**

| Component  | Name                    | Status    | Notes                   |
| ---------- | ----------------------- | --------- | ----------------------- |
| Deployment | nginx-deployment        | ✅ Running | 3 replicas              |
| Container  | nginx-container         | ✅         | nginx:latest            |
| Service    | nginx-service           | ✅ Created | NodePort 30011          |
| Pods       | 3 Running               | ✅         | Healthy                 |
| Node       | kodekloud-control-plane | ✅         | Internal IP: 172.17.0.2 |

---
