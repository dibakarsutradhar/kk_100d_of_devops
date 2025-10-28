# 🧾 Kubernetes Shared Volume Task Report

### **Task Summary**

The objective was to create a **multi-container pod** where both containers share a common `emptyDir` volume for temporary data exchange. The setup demonstrates inter-container file visibility within the same pod using shared storage.

---

### **🔧 Pod Configuration Details**

| Component                     | Name / Value                  |
| ----------------------------- | ----------------------------- |
| **Pod Name**                  | `volume-share-nautilus`       |
| **Container 1 Name**          | `volume-container-nautilus-1` |
| **Container 2 Name**          | `volume-container-nautilus-2` |
| **Container Image**           | `debian:latest`               |
| **Shared Volume Name**        | `volume-share`                |
| **Volume Type**               | `emptyDir`                    |
| **Mount Path (Container 1)**  | `/tmp/official`               |
| **Mount Path (Container 2)**  | `/tmp/demo`                   |
| **Command (Both Containers)** | `sleep 3600`                  |

---

### **📄 YAML Manifest**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-nautilus
spec:
  containers:
    - name: volume-container-nautilus-1
      image: debian:latest
      command: ["sleep", "3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/official

    - name: volume-container-nautilus-2
      image: debian:latest
      command: ["sleep", "3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/demo

  volumes:
    - name: volume-share
      emptyDir: {}
```

---

### **🧠 Steps Performed**

1. **Created the Pod YAML**
   Defined both containers, mounted the same `emptyDir` volume, and specified `sleep 3600` to keep them running.

2. **Deployed the Pod**

   ```bash
   kubectl apply -f volume-share-nautilus.yaml
   ```

   Verified both containers are running:

   ```
   NAME                     READY   STATUS    RESTARTS   AGE
   volume-share-nautilus    2/2     Running   0          15s
   ```

3. **Created File in Container 1**

   ```bash
   kubectl exec -it volume-share-nautilus -c volume-container-nautilus-1 -- bash
   cd /tmp/official
   echo "This is shared volume test" > official.txt
   exit
   ```

4. **Verified File in Container 2**

   ```bash
   kubectl exec -it volume-share-nautilus -c volume-container-nautilus-2 -- bash
   ls /tmp/demo
   cat /tmp/demo/official.txt
   ```

   Output confirmed the file `official.txt` was visible and contained the expected text.

---

### **✅ Validation Results**

| Check                                           | Status |
| ----------------------------------------------- | ------ |
| Pod named correctly                             | ✅      |
| Containers named correctly                      | ✅      |
| Shared volume configured as `emptyDir`          | ✅      |
| File `official.txt` created in `/tmp/official`  | ✅      |
| File visible in `/tmp/demo` on second container | ✅      |
| Both containers remained in `Running` state     | ✅      |

---

### **📘 Conclusion**

The shared volume setup using `emptyDir` was successfully implemented.
Both containers (`volume-container-nautilus-1` and `volume-container-nautilus-2`) were able to read and write to the same storage, confirming that inter-container communication through shared volumes works as intended in Kubernetes.

---
