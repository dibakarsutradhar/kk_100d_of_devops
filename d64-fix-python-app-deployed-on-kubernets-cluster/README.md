# Fix Python App Deployment (`python-deployment-xfusion`)

---

### **Objective**

The task was to troubleshoot and fix a Python Flask application (`python-deployment-xfusion`) deployed on a Kubernetes cluster. The app was supposed to be accessible via NodePort `32345`, but initially, it was returning a **502 Bad Gateway** error.

---

### **Root Cause Analysis**

Upon investigation, the following issues were identified:

1. **Incorrect container image**

   * The deployment was originally using a non-existent image:

     ```
     poroko/flask-app-demo
     ```
   * This caused the pod to remain in a `ImagePullBackOff` state because the image could not be pulled from Docker Hub.

2. **Incorrect Service configuration**

   * The Kubernetes Service `python-service-xfusion` was configured with:

     ```yaml
     port: 8080
     targetPort: 8080
     nodePort: 32345
     ```
   * However, Flask applications by default listen on **port 5000**, not 8080.
   * As a result, the Service was forwarding traffic to a non-existent port inside the pod, leading to the **502 Bad Gateway** response.

---

### **Fix Implementation**

#### **Step 1 — Correct the Deployment Image**

The image was corrected by editing the deployment directly:

```bash
kubectl edit deployment python-deployment-xfusion
```

Inside the editor, the container image was updated to a valid one:

```yaml
spec:
  containers:
  - name: python-container-xfusion
    image: poroko/flask-demo-appimage
    ports:
    - containerPort: 5000
```

After saving and closing the editor, the deployment automatically rolled out the updated pod.

To verify:

```bash
kubectl get pods
```

Output:

```
NAME                                         READY   STATUS    RESTARTS   AGE
python-deployment-xfusion-7d7bc7c88c-7gksq   1/1     Running   0          1m
```

The pod was successfully running.

---

#### **Step 2 — Fix the Service TargetPort**

The Service was still forwarding to port `8080`. It needed to be updated to match Flask’s default port (`5000`).

This was fixed using a patch command:

```bash
kubectl patch svc python-service-xfusion \
  --type='json' \
  -p='[
        {"op":"replace","path":"/spec/ports/0/port","value":5000},
        {"op":"replace","path":"/spec/ports/0/targetPort","value":5000}
      ]'
```

Alternatively, the service could have been edited manually:

```bash
kubectl edit svc python-service-xfusion
```

And the relevant section updated to:

```yaml
spec:
  ports:
  - port: 5000
    targetPort: 5000
    nodePort: 32345
    protocol: TCP
```

---

#### **Step 3 — Verify the Service and Pod Configuration**

Check service details:

```bash
kubectl describe svc python-service-xfusion
```

**Expected Output:**

```
Name:                     python-service-xfusion
Namespace:                default
Type:                     NodePort
IP:                       10.96.39.17
Port:                     5000/TCP
TargetPort:               5000/TCP
NodePort:                 32345/TCP
Endpoints:                10.244.0.7:5000
```

Check endpoints:

```bash
kubectl get endpoints python-service-xfusion
```

Expected output:

```
NAME                     ENDPOINTS          AGE
python-service-xfusion   10.244.0.7:5000    10m
```

Check that Flask is listening inside the container:

```bash
POD=$(kubectl get pods -l app=python_app -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD -- curl -I http://localhost:5000
```

Expected response:

```
HTTP/1.0 200 OK
Server: Werkzeug/2.0.3 Python/3.8.10
Date: Fri, 07 Nov 2025 19:40:00 GMT
Content-Type: text/html; charset=utf-8
```

---

#### **Step 4 — External Access Test**

Once the service was corrected, external access was tested via NodePort:

```bash
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
curl http://$NODE_IP:32345
```

**Expected Output:**

```
<!doctype html>
<html lang="en">
  <head><title>Flask Demo App</title></head>
  <body><h1>Welcome to the Flask Demo Application!</h1></body>
</html>
```

This confirmed that the Flask application was now reachable on the specified NodePort (`32345`).

---

### **Final Working Configuration**

#### **Deployment (Fixed)**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-deployment-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: python_app
  template:
    metadata:
      labels:
        app: python_app
    spec:
      containers:
      - name: python-container-xfusion
        image: poroko/flask-demo-appimage
        ports:
        - containerPort: 5000
```

#### **Service (Fixed)**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-service-xfusion
spec:
  type: NodePort
  selector:
    app: python_app
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 5000
    nodePort: 32345
```

---

### **Verification Summary**

| Checkpoint       | Command                                        | Result                   |
| ---------------- | ---------------------------------------------- | ------------------------ |
| Pod Running      | `kubectl get pods`                             | ✅ Running                |
| Image Valid      | `kubectl describe pod`                         | ✅ Pull Successful        |
| Port Mapping     | `kubectl describe svc`                         | ✅ 5000 → 5000            |
| Flask Response   | `curl http://NODE_IP:32345`                    | ✅ HTML Output            |
| Endpoints Active | `kubectl get endpoints python-service-xfusion` | ✅ Correct Endpoint Shown |

---

### **Conclusion**

The Flask application was failing due to:

1. Incorrect Docker image name
2. Wrong Service target port configuration

After correcting both issues, the app became accessible on the expected NodePort `32345`. All pods, services, and endpoints are now correctly configured and operational.

