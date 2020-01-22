#!/bin/bash

mount.davfs https://podaac-tools.jpl.nasa.gov/drive/files /mnt/podaac_drive
export PODAAC_DRIVE_PATH=$1
export LOCAL_FS_PATH=$2
rsync -a /mnt/podaac_drive/$PODAAC_DRIVE_PATH $LOCAL_FS_PATH

