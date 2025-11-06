# Iron Gallery Kubernetes Deployment Report

## Objective
The Nautilus DevOps team needed to deploy the Iron Gallery application and its MariaDB backend on a Kubernetes cluster. This report details the configuration, applied YAML manifests, verification commands, and results.

---

## 1. Namespace Creation

A dedicated namespace was created to isolate the Iron Gallery application and its database components.

### YAML: `iron-namespace.yaml`
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: iron-namespace-nautilus
```

### Command

```bash
kubectl apply -f iron-namespace.yaml
```

### Verification

```bash
kubectl get ns
```

**Output:**

```
NAME                      STATUS   AGE
iron-namespace-nautilus   Active   18m
```

---

## 2. Iron Gallery Deployment

This deployment runs the front-end Iron Gallery application with two emptyDir volumes.

### YAML: `iron-gallery-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-gallery-deployment-nautilus
  namespace: iron-namespace-nautilus
  labels:
    run: iron-gallery
spec:
  replicas: 1
  selector:
    matchLabels:
      run: iron-gallery
  template:
    metadata:
      labels:
        run: iron-gallery
    spec:
      containers:
      - name: iron-gallery-container-nautilus
        image: kodekloud/irongallery:2.0
        resources:
          limits:
            memory: "100Mi"
            cpu: "50m"
        volumeMounts:
        - name: config
          mountPath: /usr/share/nginx/html/data
        - name: images
          mountPath: /usr/share/nginx/html/uploads
      volumes:
      - name: config
        emptyDir: {}
      - name: images
        emptyDir: {}
```

### Command

```bash
kubectl apply -f iron-gallery-deployment.yaml
```

---

## 3. Iron DB Deployment

The MariaDB backend for Iron Gallery was deployed with required environment variables and an emptyDir volume for database storage.

### YAML: `iron-db-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-db-deployment-nautilus
  namespace: iron-namespace-nautilus
  labels:
    db: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      db: mariadb
  template:
    metadata:
      labels:
        db: mariadb
    spec:
      containers:
      - name: iron-db-container-nautilus
        image: kodekloud/irondb:2.0
        env:
        - name: MYSQL_DATABASE
          value: database_blog
        - name: MYSQL_USER
          value: ironuser
        - name: MYSQL_PASSWORD
          value: S3cur3Pa55@123
        - name: MYSQL_ROOT_PASSWORD
          value: C0mpl3xR00t@123
        volumeMounts:
        - name: db
          mountPath: /var/lib/mysql
      volumes:
      - name: db
        emptyDir: {}
```

### Command

```bash
kubectl apply -f iron-db-deployment.yaml
```

---

## 4. Services

Two services were created:

* A **ClusterIP** service for the internal MariaDB database.
* A **NodePort** service for external access to the Iron Gallery front-end.

### YAML: `iron-db-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-db-service-nautilus
  namespace: iron-namespace-nautilus
spec:
  selector:
    db: mariadb
  type: ClusterIP
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
```

### YAML: `iron-gallery-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-gallery-service-nautilus
  namespace: iron-namespace-nautilus
spec:
  selector:
    run: iron-gallery
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 32678
```

### Commands

```bash
kubectl apply -f iron-db-service.yaml
kubectl apply -f iron-gallery-service.yaml
```

---

## 5. Verification

### Command

```bash
kubectl get all -n iron-namespace-nautilus
```

### Output

```
NAME                                                    READY   STATUS    RESTARTS   AGE
pod/iron-db-deployment-nautilus-8d7b69847-788jh         1/1     Running   0          5m53s
pod/iron-gallery-deployment-nautilus-7cf86c44d7-57zl4   1/1     Running   0          12m

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/iron-db-service-nautilus        ClusterIP   10.96.186.131   <none>        3306/TCP       3m40s
service/iron-gallery-service-nautilus   NodePort    10.96.172.110   <none>        80:32678/TCP   16s

NAME                                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/iron-db-deployment-nautilus        1/1     1            1           5m53s
deployment.apps/iron-gallery-deployment-nautilus   1/1     1            1           12m

NAME                                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/iron-db-deployment-nautilus-8d7b69847         1         1         1       5m53s
replicaset.apps/iron-gallery-deployment-nautilus-7cf86c44d7   1         1         1       12m
```

---

## 6. Accessing the Application

Retrieve the Node’s IP:

```bash
kubectl get nodes -o wide
```

Access the Iron Gallery in a browser or using curl:

```
http://<NODE-IP>:32678
```

If the installation or setup page of Iron Gallery loads, the deployment is successful.

---

## 7. Verification of Service Details

### Command

```bash
kubectl describe svc iron-gallery-service-nautilus -n iron-namespace-nautilus
```

### Output (Excerpt)

```
Name:                     iron-gallery-service-nautilus
Namespace:                iron-namespace-nautilus
Type:                     NodePort
IP:                       10.96.172.110
Port:                     80/TCP
TargetPort:               80/TCP
NodePort:                 32678/TCP
Endpoints:                10.244.0.5:80
```

---

## 8. Final Status Summary

| Resource Type | Name                             | Status                   | Namespace               |
| ------------- | -------------------------------- | ------------------------ | ----------------------- |
| Namespace     | iron-namespace-nautilus          | Active                   | default                 |
| Deployment    | iron-gallery-deployment-nautilus | Running                  | iron-namespace-nautilus |
| Deployment    | iron-db-deployment-nautilus      | Running                  | iron-namespace-nautilus |
| Service       | iron-db-service-nautilus         | Active (ClusterIP)       | iron-namespace-nautilus |
| Service       | iron-gallery-service-nautilus    | Active (NodePort: 32678) | iron-namespace-nautilus |

---

## Conclusion

All Kubernetes resources for the Iron Gallery application and its database were successfully deployed in the `iron-namespace-nautilus` namespace. Both deployments are running as expected, and the application is accessible via the NodePort service on port `32678`.
