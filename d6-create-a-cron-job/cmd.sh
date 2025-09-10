## install cronie
sudo yum install cronie
## start crond service
sudo systemctl start crond
## enable crond service to start automatically at system boot
sudo systemctl enable crond

## add a cron for root user
sudo crontab -e -u root
## this should open crontab on nano
## insert the following cron config
*/5 * * * echo hello > /tmp/cron_text
## save the file and exit the editor

## the cron job will run every 5 minutes and 
## echo `hello` to the `/tmp/cron_text` file

## check the server after 5 minutes
cat /tmp/cron_text
## it should print `hello` in the terminal

## follow the same steps in every app server
