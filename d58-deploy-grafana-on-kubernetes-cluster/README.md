# Kubernetes Task Report: Grafana Deployment Setup

### Task Summary

The Nautilus DevOps team planned to deploy Grafana on the Kubernetes cluster for monitoring and analytics.
The goal was to create a deployment running a Grafana container and expose it using a NodePort service accessible on port **32000**.

---

## Configuration Details

| Resource Type   | Name                         | Description                           |
| --------------- | ---------------------------- | ------------------------------------- |
| Deployment      | `grafana-deployment-xfusion` | Deploys Grafana app                   |
| Container Image | `grafana/grafana:latest`     | Official Grafana image                |
| Service         | `grafana-service`            | NodePort service exposing Grafana     |
| NodePort        | `32000`                      | Exposes Grafana login page externally |
| Port            | `3000`                       | Default Grafana web interface port    |
| Replicas        | `1`                          | Single instance (can be scaled later) |

---

## Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana-container
          image: grafana/grafana:latest
          ports:
            - containerPort: 3000
```

---

## Service YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana-service
spec:
  type: NodePort
  selector:
    app: grafana
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```

---

## Execution Steps

1. **Create Deployment**

   ```bash
   kubectl apply -f grafana-deployment.yaml
   ```

2. **Create Service**

   ```bash
   kubectl apply -f grafana-service.yaml
   ```

3. **Verify Deployment and Pods**

   ```bash
   kubectl get deployments
   kubectl get pods -o wide
   ```

   Example output:

   ```
   NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
   grafana-deployment-xfusion  1/1     1            1           30s
   ```

4. **Verify Service**

   ```bash
   kubectl get svc grafana-service
   ```

   Example output:

   ```
   NAME              TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
   grafana-service   NodePort   10.96.23.119   <none>        3000:32000/TCP   10s
   ```

5. **Access Grafana UI**
   Open browser and navigate to:

   ```
   http://<Node-IP>:32000
   ```

   Expected Result: Grafana login page visible (default username: `admin`, password: `admin`)

---

## Outcome

* Grafana successfully deployed via Kubernetes Deployment.
* Application exposed using NodePort (32000).
* Login page accessible through browser.

**Verification Passed — Deployment operational and reachable.**

