#!/bin/bash

# Script to tar up music directory and upload to roger
# NOTE: Needs tar and scp installed

# File and text variables
backup_dir="$HOME/Music"
remote_server="roger"
formatted_date=`date +%Y_%m_%d`
tar_file="acda_music_$formatted_date.tar.gz"

parent_dir=$HOME
cd ${parent_dir}

# tar and scp it
# echo "attempting to tar up file"
# tar czvf ${tar_file} ${backup_dir};

# # check tar file exists (exit if not)
# if [ ! -f ${tar_file} ]; then
#     /bin/echo "${tar_file} not found!";
#     exit 1;
# else
#     echo "copying ${tar_file} to ${remote_server}"
#     scp ${tar_file} ${remote_server}:
# fi

# rsync it
echo "attempting to rsync ${backup_dir} to ${remote_server}"
rsync -avzhe ssh --progress ${backup_dir} ${remote_server}:~
