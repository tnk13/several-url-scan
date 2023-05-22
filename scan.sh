#!/bin/bash

# Set the input file and output directory
input_file="/home/kali/urls.txt"
output_dir="/home/kali/Desktop"

# Set the maximum number of concurrent jobs
max_jobs=5

# Define a function to run dirb
function run_dirb {
    local protocol="$1"
    local url="$2"
    local output_file="$3"
    local name="$(echo $url | grep $url | sed 's/:/-/g')"
    dirb "$protocol://$url" /home/usr/wordlists.txt -o "${output_dir}/${output_file}_${name}.dirb" >/dev/null 2>&1
}

# Run dirb for HTTPS URLs ( change or + http, IP)
while read -r url; do
    while [ "$(jobs -r | wc -l)" -ge "$max_jobs" ]; do
        sleep 5
    done
    run_dirb "https" "$url" "https" &
done < "$input_file"

# Wait for all jobs to complete
wait

# Output a message indicating that the script has completed
echo "Script completed" >> "$output_dir/output.txt"
