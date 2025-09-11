## create authentication SSH-Keygen Keys
ssh-keygen -t rsa

## copy the public id and upload it to remote servers
ssh-copy-id steve@stapp02

## try loging into the remote server without password
ssh steve@stapp02
