# Guestbook Application Deployment Report

## Objective

Deploy a **three-tier Guestbook application** on a Kubernetes cluster consisting of:

* **Redis Master (Backend Tier)**
* **Redis Slave (Backend Tier)**
* **Frontend (Frontend Tier)**

All deployments and services were verified using `kubectl`.

---

## Step 1: Redis Master Deployment and Service

### **redis-master.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-master
  labels:
    app: redis-master
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-master
  template:
    metadata:
      labels:
        app: redis-master
    spec:
      containers:
        - name: master-redis-devops
          image: redis
          ports:
            - containerPort: 6379
          resources:
            requests:
              memory: "100Mi"
              cpu: "100m"
---
apiVersion: v1
kind: Service
metadata:
  name: redis-master
  labels:
    app: redis-master
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis-master
  type: ClusterIP
```

### **Apply Deployment and Service**

```bash
thor@jumphost ~$ kubectl apply -f redis-master.yaml
deployment.apps/redis-master created
service/redis-master created
```

---

## Step 2: Redis Slave Deployment and Service

### **redis-slave.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-slave
  labels:
    app: redis-slave
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis-slave
  template:
    metadata:
      labels:
        app: redis-slave
    spec:
      containers:
        - name: slave-redis-devops
          image: gcr.io/google_samples/gb-redisslave:v3
          ports:
            - containerPort: 6379
          resources:
            requests:
              memory: "100Mi"
              cpu: "100m"
          env:
            - name: GET_HOSTS_FROM
              value: "dns"
---
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
  labels:
    app: redis-slave
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis-slave
  type: ClusterIP
```

### **Apply Deployment and Service**

```bash
thor@jumphost ~$ kubectl apply -f redis-slave.yaml
deployment.apps/redis-slave created
service/redis-slave created
```

---

## Step 3: Frontend Deployment and Service

### **frontend.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: guestbook
spec:
  replicas: 3
  selector:
    matchLabels:
      app: guestbook
  template:
    metadata:
      labels:
        app: guestbook
    spec:
      containers:
        - name: php-redis-devops
          image: gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff
          ports:
            - containerPort: 80
          resources:
            requests:
              memory: "100Mi"
              cpu: "100m"
          env:
            - name: GET_HOSTS_FROM
              value: "dns"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: guestbook
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30009
  selector:
    app: guestbook
```

### **Apply Deployment and Service**

```bash
thor@jumphost ~$ kubectl apply -f frontend.yaml
deployment.apps/frontend created
service/frontend created
```

---

## Step 4: Verification

### **Check Deployments**

```bash
thor@jumphost ~$ kubectl get deployments
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
frontend       3/3     3            3           3m26s
redis-master   1/1     1            1           16m
redis-slave    2/2     2            2           11m
```

### **Check Pods**

```bash
thor@jumphost ~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
frontend-cddd497bb-cq4k2        1/1     Running   0          3m34s
frontend-cddd497bb-ffp76        1/1     Running   0          3m34s
frontend-cddd497bb-xwwcn        1/1     Running   0          3m34s
redis-master-5587f87489-glns6   1/1     Running   0          16m
redis-slave-6594f4ddb6-c2mbm    1/1     Running   0          11m
redis-slave-6594f4ddb6-vg2gs    1/1     Running   0          11m
```

### **Check Services**

```bash
thor@jumphost ~$ kubectl get svc
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
frontend       NodePort    10.96.183.92    <none>        80:30009/TCP   30s
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP        29m
redis-master   ClusterIP   10.96.222.82    <none>        6379/TCP       14m
redis-slave    ClusterIP   10.96.107.139   <none>        6379/TCP       9m4s
```

---

## Step 5: Access the Application

Once all pods and services are running successfully, the **Guestbook frontend** can be accessed on any Kubernetes node at:

```
http://<NodeIP>:30009
```

---

## Final Summary

| Component    | Type       | Replicas  | Port(s) | NodePort | Status  |
| ------------ | ---------- | --------- | ------- | -------- | ------- |
| redis-master | Deployment | 1         | 6379    | —        | Running |
| redis-slave  | Deployment | 2         | 6379    | —        | Running |
| frontend     | Deployment | 3         | 80      | 30009    | Running |
| redis-master | Service    | ClusterIP | 6379    | —        | Active  |
| redis-slave  | Service    | ClusterIP | 6379    | —        | Active  |
| frontend     | Service    | NodePort  | 80      | 30009    | Active  |

---
