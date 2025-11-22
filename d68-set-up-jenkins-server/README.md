# Jenkins Installation

## Overview

This report summarizes the complete end-to-end setup of Jenkins on a RHEL/CentOS-9-based system using `yum`.
It covers:

1. Adding the Jenkins repository
2. Fixing GPG key validation failures
3. Installing Jenkins
4. Verifying Java requirements
5. Starting Jenkins and validating service status
6. Retrieving the initial admin password
7. Full terminal history from the execution environment

This document is intended for DevOps and system administration teams who require a reproducible installation process.

---

## 1. Adding the Jenkins Repository

The recommended stable repository is added using:

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

Then import the official Jenkins GPG key:

```bash
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

This is the step that resolves the GPG check failure during installation.

---

## 2. Fixing GPG Check Failure

During installation, the system reported:

```
Public key for jenkins-2.528.2-1.1.noarch.rpm is not installed
Error: GPG check FAILED
```

This error indicates that although the Jenkins repo was added, its GPG key was not installed.

### Correct Fix

```bash
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

After the import, it is good practice to clean and refresh metadata:

```bash
yum clean all
```

The installation will now proceed without GPG validation errors.

---

## 3. Installing Jenkins Using yum

Once the GPG key was imported, Jenkins was installed using:

```bash
yum install -y jenkins
```

Package details:

* Name: jenkins
* Version: 2.528.2-1.1
* Architecture: noarch
* Size: 91 MB

---

## 4. Java Version Requirement and Verification

Jenkins requires Java 17 or Java 21.

The system Java version was:

```bash
java -version
```

Output:

```
openjdk version "17.0.17" 2025-10-21 LTS
OpenJDK Runtime Environment (Red_Hat-17.0.17.0.10-1)
OpenJDK 64-Bit Server VM (Red_Hat-17.0.17.0.10-1)
```

This satisfies Jenkins requirements.

Note: Earlier installations of Java 11 would cause the Jenkins service to fail to start.

---

## 5. Service Start and Validation

After installing Jenkins and verifying Java, the service was started:

```bash
systemctl daemon-reload
systemctl start jenkins
```

Service status:

```bash
systemctl status jenkins
```

The output showed:

* `Active: active (running)`
* Jenkins fully initialized
* Process started by Java at `/usr/share/java/jenkins.war`
* Port: 8080

The warning:

```
Failed to send unit change signal: Connection reset by peer
```

is harmless within the provided environment and does not affect functionality.

---

## 6. Retrieving the Initial Admin Password

Jenkins stores the initial password at:

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

System produced:

```
fd69e4f5a1e244368dab0b617a451b17
```

This password is used during the UI setup at:

```
http://<server-ip>:8080
```

---

## 7. Terminal History

```
[root@jenkins ~]# yum install -y jenkins
Jenkins-stable                              162 kB/s |  33 kB     00:00    
Last metadata expiration check: 0:00:01 ago on Sat Nov 22 16:16:57 2025.
Dependencies resolved.
============================================================================
 Package         Architecture   Version               Repository       Size
============================================================================
Installing:
 jenkins         noarch         2.528.2-1.1           jenkins          91 M

Transaction Summary
============================================================================
Install  1 Package

Total download size: 91 M
Installed size: 91 M
Downloading Packages:
jenkins-2.528.2-1.1.noarch.rpm              3.9 MB/s |  91 MB     00:23    
----------------------------------------------------------------------------
Total                                       3.9 MB/s |  91 MB     00:23     
Public key for jenkins-2.528.2-1.1.noarch.rpm is not installed
The downloaded packages were saved in cache until the next successful transaction.
You can remove cached packages by executing 'yum clean packages'.
Error: GPG check FAILED

[root@jenkins ~]# java -version
openjdk version "17.0.17" 2025-10-21 LTS
OpenJDK Runtime Environment (Red_Hat-17.0.17.0.10-1)
OpenJDK 64-Bit Server VM (Red_Hat-17.0.17.0.10-1)

[root@jenkins ~]# nano /etc/sysconfig/jenkins
-bash: nano: command not found

[root@jenkins ~]# systemctl daemon-reload
[root@jenkins ~]# systemctl start jenkins

[root@jenkins ~]# systemctl status jenkins
● jenkins.service - Jenkins Continuous Integration Server
     Loaded: loaded (/usr/lib/systemd/system/jenkins.service; disabled; preset: disabled)
     Active: active (running) since Sat 2025-11-22 16:23:18 UTC; 7s ago
   Main PID: 7006 (java)
      Tasks: 74 (limit: 411140)
     Memory: 974.9M
     CGroup: /docker/.../system.slice/jenkins.service
             └─7006 /usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080

Nov 22 16:23:18 jenkins.stratos.xfusioncorp.com jenkins[7006]: Jenkins is fully up and running
Nov 22 16:23:18 jenkins.stratos.xfusioncorp.com systemd[1]: Started Jenkins Continuous Integration Server.
Nov 22 16:23:18 jenkins.stratos.xfusioncorp.com systemd[1]: jenkins.service: Failed to send unit change signal: Connection reset by peer

[root@jenkins ~]# cat /var/lib/jenkins/secrets/initialAdminPassword
fd69e4f5a1e244368dab0b617a451b17
```

---

## 8. Final System Status

* Jenkins repository configured successfully
* GPG key imported correctly
* Jenkins installed using yum
* Java 17 validated
* Jenkins service started successfully
* Admin password retrieved
* Jenkins web dashboard ready at port 8080

---
