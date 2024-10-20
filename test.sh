


log_dir="./log"
file_size=2 #size of each test file
main_dir="./backup"
function create_disk() {
    local size_of_disk="$1"
    ./create_limited_folder.sh "$size_of_disk"
}

function generate_files() {
    local folder_size="$1"
    local file_count=$((folder_size / file_size)) #number of files 
    echo "file size: $file_size"
    echo "file count: $file_count"
    #echo "generating $file_count files $file_size MB each file in $log_dir directory..."

    for i in $(seq 1 "$file_count"); do

        sudo dd if=/dev/zero of="$log_dir/logfile$i.log" bs=1M count="$file_size" status=none
        sleep 0.1
    done
}

run() {
    local threshold="$1"
    local n_files="${2:-5}"
    echo "starting test: max = $threshold%, archieve $n_files files"
    sudo ./main_script.sh "$log_dir" "$threshold" "$n_files"
    #check results
    local archived_files=$(tar -tzf "$main_dir"/*.tar.gz 2> /dev/null | wc -l)
    local remaining_files=$(ls "$log_dir" | wc -l)

    echo "SUCCESS - Files archieved: $archived_files"
    echo "SUCCESS - Files remaining: $remaining_files"
}

run_tests() {
    echo "Test 0: Check of the correct accomplishment"
    create_disk 50 
    generate_files 10
    #run 10 3
}

run_tests