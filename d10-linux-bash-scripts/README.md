The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on App Server 2 in Stratos Datacenter, and they need to create a bash script named news_backup.sh which should accomplish the following tasks. (Also remember to place the script under /scripts directory on App Server 2).

a. Create a zip archive named xfusioncorp_news.zip of /var/www/html/news directory.

b. Save the archive in /backup/ on App Server 2. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.

c. Copy the created archive to Nautilus Backup Server server in /backup/ location.

d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.

e. Do not use sudo inside the script.

Note:
The zip package must be installed on given App Server before executing the script. This package is essential for creating the zip archive of the website files. Install it manually outside the script.

```
# install zip package
sudo yum install zip -y
zip -v

# create the sciprt folder
sudo mkdir -p /scripts/

# create the script and open it in vim
sudo vi /scripts/news_backup.sh

# make the script executable
sudo chmod +x /scripts/news_backup.sh

# generate ssh public key
ssh-keygen -t rsa

# Copy the SSH public key to the remote server
ssh-copy-id clint@stbkp01

# Run as the application user on App Server 2:
/scripts/news_backup.sh
-> xfusioncorp_news.zip                                                           100%  588     1.7MB/s   00:00    
-> Backup completed successfully.

# verify
ssh clint@stbkp01
-> Last login: Mon Sep 15 17:29:34 2025 from 172.16.238.11
ls -l /backup/
-> total 4
-> -rw-r--r-- 1 clint clint 588 Sep 15 17:41 xfusioncorp_news.zip
```
