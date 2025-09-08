In a bid to automate backup processes, the xFusionCorp Industries sysadmin team has developed a new bash script named xfusioncorp.sh. While the script has been distributed to all necessary servers, it lacks executable permissions on App Server 2 within the Stratos Datacenter.

Your task is to grant executable permissions to the /tmp/xfusioncorp.sh script on App Server 2. Additionally, ensure that all users have the capability to execute it.`

```bash
sudo chmod a+rx /tmp/xfusioncorp.sh
```

chmod -> change file permissions in linux
a -> grant permission for everyone
+ -> makes the file executable 
r -> read
x -> execute
