#create a folder that will have an unique name - date
date_time=$(date +%Y%m%d_%H%M%S) 
image_of_file="$HOME/backup_for_laba/disk_$date_time.img" #create an image
mount_folder="$HOME/backup_for_laba/disk_$date_time"  #where to mount on
size_mb=${1:-1000} 

#creating a virtual disk
sudo dd if=/dev/zero of=$image_of_file bs=1M count=$size_mb
sudo mke2fs -t ext4 -F "$image_of_file" > /dev/null 2>&1 #formating as ext4
sudo mkdir -p $mount_folder #creating a directory for mounting if it doesnt exist
sudo mount "$image_of_file" "$mount_folder" 

echo "virtual disk was mounted on $mount_folder"