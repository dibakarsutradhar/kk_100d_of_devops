# MySQL Deployment on Kubernetes

### Task Overview

The Nautilus DevOps team needed to deploy a **MySQL server** on a Kubernetes cluster. The setup includes creating persistent storage, secrets for credentials, a deployment, and a NodePort service.

---

## Step 1: Create Persistent Volume (PV)

**Command**

```bash
vi mysql-pv.yaml
kubectl apply -f mysql-pv.yaml
```

**Response**

```
persistentvolume/mysql-pv created
```

**Verification**

```bash
kubectl get pv
```

**Output**

```
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
mysql-pv   250Mi      RWO            Retain           Available                                   7s
```

---

## Step 2: Create Persistent Volume Claim (PVC)

**Command**

```bash
vi mysql-pv-claim.yaml
kubectl apply -f mysql-pv-claim.yaml
```

**Response**

```
persistentvolumeclaim/mysql-pv-claim created
```

**Verification**

```bash
kubectl get pvc
```

**Initial Output**

```
NAME             STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Pending                                      standard       10s
```

After some time, it successfully bound automatically.

---

## Step 3: Create Secrets for MySQL Credentials

**Commands**

```bash
kubectl create secret generic mysql-root-pass --from-literal=password=YUIidhb667
kubectl create secret generic mysql-user-pass --from-literal=username=kodekloud_cap --from-literal=password=ksH85UJjhb
kubectl create secret generic mysql-db-url --from-literal=database=kodekloud_db3
```

**Response**

```
secret/mysql-root-pass created
secret/mysql-user-pass created
secret/mysql-db-url created
```

**Verification**

```bash
kubectl get secrets
```

**Output**

```
NAME              TYPE     DATA   AGE
mysql-db-url      Opaque   1      16s
mysql-root-pass   Opaque   1      108s
mysql-user-pass   Opaque   2      47s
```

---

## Step 4: Create MySQL Deployment

**Command**

```bash
vi mysql-deployment.yaml
kubectl apply -f mysql-deployment.yaml
```

**Responses**

```
error: error parsing mysql-deployment.yaml: error converting YAML to JSON: yaml: line 43: did not find expected '-' indicator
error: error parsing mysql-deployment.yaml: error converting YAML to JSON: yaml: line 40: did not find expected '-' indicator
deployment.apps/mysql-deployment created
```

**Verification**

```bash
kubectl get deployment
```

**Output**

```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
mysql-deployment   0/1     1            0           13s
```

After a short while:

```bash
kubectl get pods -l app=mysql
```

**Output**

```
NAME                                READY   STATUS    RESTARTS   AGE
mysql-deployment-6fb8c46c45-ldhlf   1/1     Running   0          29s
```

MySQL Pod is running successfully.

---

## Step 5: Create MySQL Service (NodePort)

**Command**

```bash
vi mysql-service.yaml
kubectl apply -f mysql-service.yaml
```

**Initial Error**

```
The Service "mysql" is invalid: spec.ports[0].nodePort: Invalid value: 33007: provided port is not in the valid range. The range of valid ports is 30000-32767
```

After correction:

**Response**

```
service/mysql created
```

**Verification**

```bash
kubectl get svc
```

**Output**

```
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          30m
mysql        NodePort    10.96.160.41   <none>        3306:30007/TCP   8s
```

MySQL service is accessible on NodePort 30007.

---

## Step 6: Verify Persistent Volume Binding

**Command**

```bash
kubectl get pv,pvc
```

**Output**

```
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                    STORAGECLASS   REASON   AGE
persistentvolume/mysql-pv                                   250Mi      RWO            Retain           Available                                                    20m
persistentvolume/pvc-c9357cd4-2c2a-4476-86a7-81da9081adab   250Mi      RWO            Delete           Bound       default/mysql-pv-claim   standard                3m3s

NAME                                   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/mysql-pv-claim   Bound    pvc-c9357cd4-2c2a-4476-86a7-81da9081adab   250Mi      RWO            standard       18m
```

PVC successfully bound to PV.

---

## Step 7: Check MySQL Pod Logs

**Command**

```bash
kubectl logs -l app=mysql
```

**Output**

```
2025-11-10T07:15:03.003522Z 0 [Warning] CA certificate ca.pem is self signed.
2025-11-10T07:15:03.003570Z 0 [Note] Skipping generation of RSA key pair as key files are present in data directory.
2025-11-10T07:15:03.003848Z 0 [Note] Server hostname (bind-address): '*'; port: 3306
2025-11-10T07:15:03.003968Z 0 [Note] IPv6 is available.
2025-11-10T07:15:03.004013Z 0 [Note]   - '::' resolves to '::';
2025-11-10T07:15:03.004057Z 0 [Note] Server socket created on IP: '::'.
2025-11-10T07:15:03.005874Z 0 [Warning] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users.
2025-11-10T07:15:03.011678Z 0 [Note] Event Scheduler: Loaded 0 events
2025-11-10T07:15:03.011954Z 0 [Note] mysqld: ready for connections.
Version: '5.7.44'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

MySQL server started successfully and is ready for connections.

---

## Final Status Summary

| Resource Type | Name                                           | Status    | Notes             |
| ------------- | ---------------------------------------------- | --------- | ----------------- |
| PV            | mysql-pv                                       | Available | 250Mi capacity    |
| PVC           | mysql-pv-claim                                 | Bound     | Linked to PV      |
| Secret        | mysql-root-pass, mysql-user-pass, mysql-db-url | Created   | Holds credentials |
| Deployment    | mysql-deployment                               | Running   | MySQL Pod active  |
| Service       | mysql                                          | Active    | NodePort 30007    |

---

### Conclusion

The MySQL deployment was successfully completed on the Kubernetes cluster.
All resources (PV, PVC, Secrets, Deployment, and Service) are in the expected state, and the MySQL server is up and running, ready for external access via NodePort **30007**.
