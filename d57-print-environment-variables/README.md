# Environment Variable Greeting Pod

### 📅 **Task Summary**

The Nautilus DevOps team required a test pod that prints a greeting message using environment variables. The pod should execute once, print the concatenated message, and then exit successfully without restarting.

---

## **Configuration Details**

### **Pod Specification**

| Property             | Value                                                         |
| -------------------- | ------------------------------------------------------------- |
| **Pod Name**         | `print-envars-greeting`                                       |
| **Container Name**   | `print-env-container`                                         |
| **Image**            | `bash`                                                        |
| **Restart Policy**   | `Never`                                                       |
| **Command Executed** | `["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']` |

---

### **Environment Variables**

| Variable   | Value      |
| ---------- | ---------- |
| `GREETING` | Welcome to |
| `COMPANY`  | DevOps     |
| `GROUP`    | Datacenter |

---

## **YAML Manifest**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  containers:
    - name: print-env-container
      image: bash
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "DevOps"
        - name: GROUP
          value: "Datacenter"
      command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
  restartPolicy: Never
```

---

## **Execution Steps**

1. **Create the pod**

   ```bash
   kubectl apply -f print-envars-greeting.yaml
   ```

   ✅ Output:

   ```
   pod/print-envars-greeting created
   ```

2. **Verify pod status**

   ```bash
   kubectl get pods
   ```

   ✅ Expected status:

   ```
   NAME                    READY   STATUS      RESTARTS   AGE
   print-envars-greeting   0/1     Completed   0          5s
   ```

3. **Check the logs**

   ```bash
   kubectl logs -f print-envars-greeting
   ```

   ✅ Output:

   ```
   Welcome to DevOps Datacenter
   ```

---

## **Outcome**

The pod executed successfully, printing the concatenated message formed from environment variables. The container completed execution and did not restart, as intended.

✅ **Verification Passed**

---
