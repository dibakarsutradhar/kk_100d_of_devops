# Redis Deployment Recovery Report

## Summary

The Redis deployment (`redis-deployment`) in the Kubernetes cluster was down due to configuration and image issues. The root cause was identified and resolved, restoring the service to a healthy state.

---

## Findings

### 1. Initial Status

```bash
kubectl get pods -l app=redis
```

**Output:**

```
0/1  ContainerCreating
```

### 2. Error Details

```bash
kubectl describe pod redis-deployment-xxxxx
```

**Error Message:**

```
MountVolume.SetUp failed for volume "config" : configmap "redis-conig" not found
```

**Root Cause:**
The `ConfigMap` name was misspelled as `redis-conig` instead of `redis-config`.

---

## Fix Steps

### Step 1 — Correct the ConfigMap reference

Updated deployment spec to point to the correct ConfigMap:

```yaml
volumes:
  - name: config
    configMap:
      name: redis-config
```

### Step 2 — Restart rollout

```bash
kubectl rollout restart deployment redis-deployment
```

**Result:**
Pods began to initialize but failed to pull the image.

---

### Step 3 — Fix image name

Checked and found typo in image name:

```
image: redis:alpin
```

Updated the image to correct version:

```bash
kubectl set image deployment/redis-deployment redis-container=redis:alpine
```

---

### Step 4 — Verify rollout

```bash
kubectl rollout status deployment redis-deployment
deployment "redis-deployment" successfully rolled out
```

Final check:

```bash
kubectl get pods -l app=redis
```

**Output:**

```
redis-deployment-5b64949698-cbtcs   1/1   Running   0   12s
```

---

## Resolution

✅ **Redis deployment restored successfully.**

* Corrected ConfigMap reference
* Fixed image name typo (`alpin` → `alpine`)
* Deployment verified and stable

---
