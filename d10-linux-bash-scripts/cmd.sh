sudo yum install zip -y

# Create the /scripts directory on App Server 2
mkdir -p /scripts

# SSH Key Setup for Passwordless Copy
ssh-keygen -t rsa 
ssh-copy-id -i ~/.ssh/id_rsa.pub clint@stbkp01

# Create the backup script
sudo vi /scripts/news_backup.sh

# Make it executable
chmod +x /scripts/news_backup.sh

# Execution: Run as the application user
/scripts/news_backup.sh

# Verify
ssh clint@stbkp01
ls -l /backup/xfusioncorp_official.zip
