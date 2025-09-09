Following a security audit, the xFusionCorp Industries security team has opted to enhance application and server security with SELinux. To initiate testing, the following requirements have been established for App server 3 in the Stratos Datacenter:



Install the required SELinux packages.

`sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted`

Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.

No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.

Disregard the current status of SELinux via the command line; the final status after the reboot should be disabled.

```bash
## open the selinux config in editor
sudo nano /etc/selinux/config

## set the SELINUX from `enforcing` to `disabled`
SELINUX=disabled

## save the file and exit
## check the selinux status
sestatus

## it should show `disabled`
```
