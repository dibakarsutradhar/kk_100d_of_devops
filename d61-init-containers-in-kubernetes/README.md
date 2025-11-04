# Kubernetes Init Container Deployment Report

## Objective

Deploy an application using a **Kubernetes Deployment** where an **init container** prepares configuration data before the main container starts. The goal is to demonstrate how `initContainers` can perform setup tasks dynamically inside a shared volume.

---

## Deployment Overview

* **Deployment Name:** `ic-deploy-nautilus`
* **Replicas:** 1
* **App Label:** `ic-nautilus`
* **Volume Type:** `emptyDir`
* **Namespace:** `default` (implicit)

---

## Implementation Details

### 1. Init Container

* **Name:** `ic-msg-nautilus`
* **Image:** `debian:latest`
* **Command:**

  ```bash
  /bin/bash -c "echo Init Done - Welcome to xFusionCorp Industries > /ic/news"
  ```
* **Purpose:**
  Writes a welcome message to `/ic/news` before the main container starts.
* **Volume Mount:**

  * **Name:** `ic-volume-nautilus`
  * **Mount Path:** `/ic`

### 2. Main Container

* **Name:** `ic-main-nautilus`
* **Image:** `debian:latest`
* **Command:**

  ```bash
  /bin/bash -c "while true; do cat /ic/news; sleep 5; done"
  ```
* **Purpose:**
  Continuously reads and outputs the message written by the init container to verify data persistence across containers.
* **Volume Mount:**

  * **Name:** `ic-volume-nautilus`
  * **Mount Path:** `/ic`

### 3. Shared Volume

* **Volume Name:** `ic-volume-nautilus`
* **Type:** `emptyDir`
* **Purpose:**
  Provides a temporary shared storage between the init container and the main container during the pod’s lifecycle.

---

## YAML Manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-nautilus
  template:
    metadata:
      labels:
        app: ic-nautilus
    spec:
      initContainers:
        - name: ic-msg-nautilus
          image: debian:latest
          command: ["/bin/bash", "-c", "echo Init Done - Welcome to xFusionCorp Industries > /ic/news"]
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
      containers:
        - name: ic-main-nautilus
          image: debian:latest
          command: ["/bin/bash", "-c", "while true; do cat /ic/news; sleep 5; done"]
          volumeMounts:
            - name: ic-volume-nautilus
              mountPath: /ic
      volumes:
        - name: ic-volume-nautilus
          emptyDir: {}
```

---

## Verification Steps

1. **Apply the manifest:**

   ```bash
   kubectl apply -f ic-deploy-nautilus.yaml
   ```

2. **Check deployment status:**

   ```bash
   kubectl get deployments
   kubectl get pods
   ```

3. **Inspect logs from the running pod:**

   ```bash
   kubectl logs -f <pod-name>
   ```

4. **Expected Output:**

   ```
   Init Done - Welcome to xFusionCorp Industries
   ```

---

## Result

The **init container** successfully executed first, created the `/ic/news` file with the welcome message, and exited.
The **main container** then started and continuously displayed the message from the shared `emptyDir` volume, confirming proper data transfer between containers.

---

## Key Takeaways

* `initContainers` are ideal for **pre-start configuration**, **data preparation**, or **dependency checks**.
* `emptyDir` volumes provide **ephemeral shared storage** accessible to all containers within the same pod.
* This approach ensures that the application containers only start once initialization is complete.

---
