The structure and instructions for using scripts for this lab work:
1) create_limited_folder.sh - this script create a virtual disk with limited size that you can choose(Mb) 
Sample of using:
./create_limited_folder SIZE
./create_limited_folder 20

2) main_script.sh - this script is for arhivation files 
Sample:
./main_script.sh FOLDER_PATH  %_of_fullness
./main_script.sh home/project  5
