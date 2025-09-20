
# 🚨 Incident Report – Apache Service Outage on App Server

**Date/Time:** 20th September 2025
**Reported by:** Monitoring system (Stratos DC)
**Service Affected:** Apache HTTPD (running on port `8082`)
**Impacted Host:** `stapp01` (172.16.238.10)

---

## 1. Problem Summary

The monitoring system reported that the Apache service was unavailable on one of the application servers in Stratos DC. Upon investigation, it was found that **`stapp01`** had its Apache service (`httpd`) in a failed state and was not listening on the required port `8082`.

---

## 2. Investigation & Findings

1. **Initial Connectivity Test (from jump host):**

   ```sh
   thor@jumphost ~$ telnet stapp01 8082
   Trying 172.16.238.10...
   telnet: connect to address 172.16.238.10: Connection refused
   ```

   * Connection was refused on `stapp01`.
   * `stapp02` and `stapp03` were reachable on port `8082`.

2. **Service Status on stapp01:**

   ```sh
   sudo systemctl status httpd
   ```

   * Apache `httpd` was in **failed state**.
   * Error logs showed:

     ```
     (98)Address already in use: AH00072: make_sock: could not bind to address [::]:8082
     no listening sockets available, shutting down
     ```
   * This indicated that **another service was already using port 8082**.

3. **Port Usage Check:**

   ```sh
   sudo netstat -tulnp | grep 8082
   ```

   * Found that **sendmail** was bound to `127.0.0.1:8082`.
   * This was blocking Apache from binding to the same port.

---

## 3. Root Cause

The **Sendmail service** was running on `stapp01` and occupying port `8082`, which caused a **port conflict**. As a result, Apache failed to start since it could not bind to its configured port.

---

## 4. Resolution Steps

The following actions were taken on `stapp01`:

1. **Stopped Sendmail:**

   ```sh
   sudo systemctl stop sendmail
   ```

2. **Disabled Sendmail from startup:**

   ```sh
   sudo systemctl disable sendmail
   ```

3. **Restarted and enabled Apache (httpd):**

   ```sh
   sudo systemctl start httpd
   sudo systemctl enable httpd
   ```

4. **Verified Apache Status:**

   ```sh
   sudo systemctl status httpd
   ```

   * Apache was running successfully.

5. **Connectivity Check from Jump Host:**

   ```sh
   thor@jumphost ~$ telnet stapp01 8082
   Connected to stapp01.
   ```

   * Apache was confirmed to be listening on port `8082`.

---

## 5. Outcome

* Apache service is now **running on all application servers (stapp01, stapp02, stapp03)**.
* Monitoring alerts have cleared.
* Port conflict issue has been fully resolved.

---

## 6. Preventive Actions

* Review system configurations to avoid unnecessary services like Sendmail running on app servers.
* Reserve port `8082` exclusively for Apache in system documentation.
* Add monitoring for **port conflicts** to detect such issues earlier.

---

✅ **Final Status:** All Apache services are active and listening on port `8082`.

---
