# **Task Report: WordPress Deployment on xFusionCorp Infra**

**Date:** 23 Sep 2025
**Prepared by:** Thor (Jump Host Operator)

---

## **1. Objective**

Deploy a WordPress website on xFusionCorp infrastructure with the following requirements:

1. Install Apache and PHP on all app servers.
2. Configure Apache to serve on port **3000**.
3. Install and configure MariaDB on the DB server.
4. Create a dedicated WordPress database and user.
5. Verify connectivity between the WordPress application and the database.

---

## **2. Infrastructure Overview**

| Server Name | IP Address    | Hostname                        | User   | Purpose         |
| ----------- | ------------- | ------------------------------- | ------ | --------------- |
| stapp01     | 172.16.238.10 | stapp01.stratos.xfusioncorp.com | tony   | Nautilus App 1  |
| stapp02     | 172.16.238.11 | stapp02.stratos.xfusioncorp.com | steve  | Nautilus App 2  |
| stapp03     | 172.16.238.12 | stapp03.stratos.xfusioncorp.com | banner | Nautilus App 3  |
| stdb01      | 172.16.239.10 | stdb01.stratos.xfusioncorp.com  | peter  | Database Server |

---

## **3. Approach**

### **Step 1: Configure App Servers (Apache + PHP)**

1. Used **Ansible** to deploy Apache and PHP on all app servers.
2. Changed the Apache listening port from default `80` to `3000`.
3. Verified connectivity with `ansible -m ping` to ensure all app servers were reachable.

**Challenges:**

* Initially failed due to **host key checking** errors in Ansible.
* Resolved by exporting `ANSIBLE_HOST_KEY_CHECKING=False`.

**Outcome:** Apache and PHP installed and running on **port 3000** on all app servers.

---

### **Step 2: Configure DB Server (MariaDB)**

1. Installed MariaDB on `stdb01`.
2. Started and enabled the service to run on boot.
3. Installed `PyMySQL` Python library to allow Ansible to manage MySQL/MariaDB.

**Challenges:**

* Failed to create the WordPress database and user using Ansible due to:

  * Access denied for `root`@`localhost`.
  * Multiple sudo and SSH passwords across servers.
* Decided to perform **database setup manually**.

---

### **Step 3: Create WordPress Database and User Manually**

1. Logged into MariaDB on `stdb01` as root:

```bash
sudo mysql -u root
```

2. Created the database and user:

```sql
CREATE DATABASE kodekloud_db3;
```

3. Created the WordPress DB user:

```sql
DROP USER IF EXISTS 'kodekloud_joy'@'%';
CREATE USER 'kodekloud_joy'@'%' IDENTIFIED BY 'BruCStnMT5';
GRANT ALL PRIVILEGES ON kodekloud_db3.* TO 'kodekloud_joy'@'%';
FLUSH PRIVILEGES;
```

**Outcome:** Database `kodekloud_db3` and user `kodekloud_joy` created successfully with full privileges.

---

### **Step 4: Verification**

1. Verified database user exists:

```sql
SELECT User, Host FROM mysql.user WHERE User='kodekloud_joy';
```

2. Checked app servers could connect to the database using the new user credentials.
3. Accessed the WordPress application via the **Load Balancer URL**.
4. Observed confirmation message:

> “App is able to connect to the database using user kodekloud\_joy”

---

## **4. Issues Encountered & Resolutions**

| Issue                             | Cause                                       | Resolution                                                    |
| --------------------------------- | ------------------------------------------- | ------------------------------------------------------------- |
| Ansible SSH password failure      | Multiple users with different passwords     | Used `ansible_become_password` in `hosts.ini` for each server |
| PHP package missing (`php-mysql`) | RHEL/CentOS 9 package name differs          | Installed `php-mysqlnd` instead                               |
| MariaDB access denied             | Ansible MySQL modules need root credentials | Created database and user manually                            |
| Firewalld module error            | `notify` used incorrectly in task           | Removed `notify` parameter from task                          |

---

## **5. Conclusion**

* All app servers now have **Apache + PHP** installed and listening on port **3000**.
* MariaDB is installed and running on `stdb01`.
* WordPress database `kodekloud_db3` and user `kodekloud_joy` successfully created.
* Application connectivity verified via Load Balancer.
* Deployment completed successfully with minor manual intervention for the database.
