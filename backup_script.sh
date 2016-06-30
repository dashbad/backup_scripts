#!/bin/bash
EXCLUDE="--exclude-from /home/dash/Documents/backup_exclude_list.txt"
#EXCLUDE=" "
SOURCE_DIR="/mnt/media/"
DEST_DIR="/mnt/media_backup/"
OPTIONS="-hrvtC --delete --delete-excluded --size-only --stats"
DEST_MOUNT="//192.168.1.8/media_backup"
BACKUP_LOG="/home/dash/Documents/backup.log"

# h = human readable
# r = recursive
# v = verbose
# t = preserve modification times
# C = auto-ignore files in the same way CVS does
# delete = delete extraneous files from dest dirs
# delete-excluded = also delete excluded files from dest dirs
# size-only = skip files that match in size
# stats = give some file-transfer stats

if mount|grep $DEST_MOUNT; then
	rsync $OPTIONS $EXCLUDE $SOURCE_DIR $DEST_DIR  > $BACKUP_LOG
	if [ $? = 0 ]; then
		cat $BACKUP_LOG | mail -s "Server Backup Report - Successful" dash
	else
		cat $BACKUP_LOG | mail -s "Server Backup Report - FAILED" dash
	fi
else
	echo "backup not mounted" | mail -s "Server Backup Report - FAILED" dash
fi
