# Redis Deployment on Kubernetes Cluster

## Objective

The Nautilus development team identified performance issues in one of their applications and decided to integrate an in-memory caching layer using **Redis**.
This document details the step-by-step process of deploying a Redis instance on a Kubernetes cluster for testing, including YAML configurations, applied commands, and terminal outputs.

---

## Step 1: Create ConfigMap for Redis Configuration

A ConfigMap named `my-redis-config` is created to define Redis settings, specifically limiting the maximum memory to `2mb`.

### YAML — `my-redis-config.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-redis-config
data:
  redis-config: |
    maxmemory 2mb
```

### Commands and Output

```bash
thor@jumphost ~$ vi my-redis-config.yaml
thor@jumphost ~$ kubectl apply -f my-redis-config.yaml 
configmap/my-redis-config created
```

Verify that the ConfigMap is created successfully:

```bash
thor@jumphost ~$ kubectl get configmap my-redis-config 
NAME              DATA   AGE
my-redis-config   1      12s
```

Detailed inspection:

```bash
thor@jumphost ~$ kubectl describe configmap my-redis-config 
Name:         my-redis-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
redis-config:
----
maxmemory 2mb

BinaryData
====

Events:  <none>
```

---

## Step 2: Create Redis Deployment

Next, we define the Redis deployment with one replica. The deployment uses the `redis:alpine` image, requests 1 CPU, and mounts two volumes:

* An **EmptyDir** named `data` mounted at `/redis-master-data`.
* A **ConfigMap** named `redis-config` mounted at `/redis-master`.

### YAML — `redis-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis-container
        image: redis:alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "1"
        volumeMounts:
        - name: data
          mountPath: /redis-master-data
        - name: redis-config
          mountPath: /redis-master
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: my-redis-config
          items:
            - key: redis-config
              path: redis.conf
```

### Commands and Output

```bash
thor@jumphost ~$ vi redis-deployment.yaml
thor@jumphost ~$ kubectl apply -f redis-deployment.yaml 
Error from server (BadRequest): error when creating "redis-deployment.yaml": Deployment in version "v1" cannot be handled as a Deployment: strict decoding error: unknown field "spec.template.spec.containers[0].images"
```

The error occurred due to a typo (`images` instead of `image`). After correcting the YAML:

```bash
thor@jumphost ~$ vi redis-deployment.yaml 
thor@jumphost ~$ kubectl apply -f redis-deployment.yaml 
deployment.apps/redis-deployment created
```

---

## Step 3: Verify the Deployment

### Check Deployment Status

```bash
thor@jumphost ~$ kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
redis-deployment   1/1     1            1           35s
```

### Describe the Deployment

```bash
thor@jumphost ~$ kubectl describe deployment redis-deployment 
Name:                   redis-deployment
Namespace:              default
CreationTimestamp:      Mon, 10 Nov 2025 06:45:16 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=redis
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=redis
  Containers:
   redis-container:
    Image:      redis:alpine
    Port:       6379/TCP
    Host Port:  0/TCP
    Requests:
      cpu:        1
    Environment:  <none>
    Mounts:
      /redis-master from redis-config (rw)
      /redis-master-data from data (rw)
  Volumes:
   data:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
   redis-config:
    Type:          ConfigMap (a volume populated by a ConfigMap)
    Name:          my-redis-config
    Optional:      false
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   redis-deployment-fd7d5749d (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  46s   deployment-controller  Scaled up replica set redis-deployment-fd7d5749d to 1
```

---

## Step 4: Check Pod Status

```bash
thor@jumphost ~$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
redis-deployment-fd7d5749d-fhjjz   1/1     Running   0          96s
```

---

## Step 5: Inspect Redis Configuration Inside the Pod

Initially, an incorrect command was used:

```bash
thor@jumphost ~$ kubectl exec -it redis-deployment --sh
error: unknown flag: --sh
See 'kubectl exec --help' for usage.
```

Correct command syntax:

```bash
thor@jumphost ~$ kubectl exec -it redis-deployment -- sh
Error from server (NotFound): pods "redis-deployment" not found
```

Pods are named dynamically, so the correct pod name was used:

```bash
thor@jumphost ~$ kubectl exec -it redis-deployment-fd7d5749d-fhjjz -- sh
/data # cat /redis-master/redis.conf 
maxmemory 2mb
/data # exit
```

The output confirms that the Redis configuration (`maxmemory 2mb`) is successfully loaded from the ConfigMap.

---

## Step 6: Verify All Redis Resources

```bash
thor@jumphost ~$ kubectl get all -l app=redis
NAME                                   READY   STATUS    RESTARTS   AGE
pod/redis-deployment-fd7d5749d-fhjjz   1/1     Running   0          2m43s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-deployment-fd7d5749d   1         1         1       2m43s
```

---

## Step 7: Summary

| Resource Type | Name                                          | Details                                             |
| ------------- | --------------------------------------------- | --------------------------------------------------- |
| ConfigMap     | `my-redis-config`                             | Defines Redis config `maxmemory 2mb`                |
| Deployment    | `redis-deployment`                            | Single replica using `redis:alpine`                 |
| Container     | `redis-container`                             | Port 6379, CPU request 1                            |
| Volumes       | `data` (EmptyDir), `redis-config` (ConfigMap) | Mounted at `/redis-master-data` and `/redis-master` |
| Status        | ✅ Running                                     | Redis Pod successfully deployed and active          |

---

## Step 8: Cleanup (Optional)

To delete all created resources:

```bash
kubectl delete deployment redis-deployment
kubectl delete configmap my-redis-config
```

---

## ✅ Final Status

The Redis deployment is **successfully running** in the Kubernetes cluster with correct configuration and mounted volumes.
Redis confirmed using the expected configuration file:

```
maxmemory 2mb
```

All pods are healthy, and the setup meets the specified task requirements.

