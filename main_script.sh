#!/bin/bash


#checking the number of arguments

if [ "$#" -lt 2 ]; then
    echo "wrong number of arguments. enter $0 FOLDER_PATH  %_of_fullness []"
    exit 1
fi

#variables

FOLDER_PATH=$1
LIMIT=$2
backup_folder="$HOME/backup_for_laba"
number_to_archive="${3:-3}"  #default number of files that will be archivating - 3

if [ -n "$(ls disk*.img 2>/dev/null)" ]; then
  image_file=$(ls -t disk*.img 2>/dev/null | head -n 1)
else
  echo "ERROR - The virtual disk image file was not found: $image_file"
  exit 1
fi

echo "the FOLDER_PATH you entered: $FOLDER_PATH"

#check whether the path exists
if [ ! -d $FOLDER_PATH ]; then
    echo "the FOLDER_PATH does not exist"
    exit 1
fi
#creating a folder where the archive will be saved
if [ ! -d "$backup_folder" ]; then
    mkdir -p "$backup_folder"
fi

FOLDER_USAGE=$(df -h $FOLDER_PATH | awk 'NR==2 {print $5}' | sed 's/.$//') #calculating a percent of usage

echo "the size of folder is $FOLDER_USAGE"

#comparison with X
if [ $FOLDER_USAGE -gt $LIMIT ]; then

    old_files=$(ls -t "$FOLDER_PATH" | head -n $number_to_archive) #ls -t -sorting starting with the odest ones, head -n - ouput only n lines
    if [ -z "$old_files" ]; then   #if the folder is without any files
        echo "folder is empty"
        exit 0
    fi
    if [ $? -eq 0 ]; then
        echo "the folder is full on $FOLDER_USAGE%. arhivation of older files started."
        archive="$backup_folder/archive_$(date +%Y%m%d_%H%M%S).tar.gz" #creating an arhive
        tar -czf "$archive" -C "$FOLDER_PATH" $old_files
        for item in $old_files; do  #deleting the files that have been arhived
            sudo rm -rf "$FOLDER_PATH/$item"
            echo "file deleted"
            echo "..."
        done
        echo "everything is done. your folder is arhivated. you can see it in /backup folder"
    else
        echo "arhivation has not started"
        exit 1
    fi
else
    echo "arhivation is not neccessary"
    exit 0
fi