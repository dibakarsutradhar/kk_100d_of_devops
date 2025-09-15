#!/bin/bash

# variables
SRC_DIR="/var/www/html/news"
TMP_BACKUP="/backup"
ARCHIVE_NAME="xfusioncorp_news.zip"
BACKUP_SERVER="stbkp01"
BACKUP_USER="clint"
REMOTE_DIR="/backup"

# create a zip archive of the directory
zip -r "${TMP_BACKUP}/${ARCHIVE_NAME}" "${SRC_DIR}" > /dev/null 2>&1

# check if archive created successfully
if [ $? -ne 0 ]; then
        echo "Error: Failed to create archive!"
        exit 1
fi

# copy the archive to the backup server
scp "${TMP_BACKUP}/${ARCHIVE_NAME}" "${BACKUP_USER}@${BACKUP_SERVER}:${REMOTE_DIR}/"

if [ $? -ne 0 ]; then
        echo "Error: Failed to copy archive to backup server!"
        exit 2
fi

echo "Backup completed successfully."          
