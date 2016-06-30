#!/bin/bash

SOURCE_PART="/dev/disk/by-uuid/be8b0d83-0594-40bc-8e76-f7700017ac87"
DEST_DIR="/mnt/backup/dash_backup/server_root"
DEST_MOUNT="/mnt/backup"
DATE=$(date +"%m_%d_%Y")

ls -t $DEST_DIR | awk 'NR>2 {system("rm /mnt/dash_backup/server_root/\"" $0 "\"")}'

if mount|grep $DEST_MOUNT; then
	/usr/sbin/fsarchiver savefs "$DEST_DIR/root_fs_$DATE.fsa"  $SOURCE_PART -v -A
	if [ $? = 0 ]; then
		echo "Success" | mail -s "RootFS Backup Report - Successful" dash
	else
		echo "Failed" | mail -s "RootFS Backup Report - FAILED" dash
	fi
else
	echo "backup not mounted" | mail -s "RootFS Backup Report - FAILED" dash
fi
