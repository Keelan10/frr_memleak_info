#!/bin/bash

# Define an indexed array with the desired order of parts
parts=("Part 0" "Part 1" "Part 2" "Part 3" "Part 4" "Part 5" "Part 6" "Part 7" "Part 8" "Part 9")

# Declare an associative array for the dictionary
declare -A dict
dict=(
  ["Part 0"]="ASAN3"
  ["Part 1"]="ASAN1"
  ["Part 2"]="ASAN2"
  ["Part 3"]="ASANP3"
  ["Part 4"]="ASANP4"
  ["Part 5"]="ASAN5"
  ["Part 6"]="ASAN6"
  ["Part 7"]="ASAN7"
  ["Part 8"]="ASAN8"
  ["Part 9"]="ASAN9"
)


# Check if the BUILD_NUM flag is set
if [ -z "$BUILD_NUM" ]; then
    echo "BUILD_NUM not set. Skipping the script."
    exit 0
fi

# Initialize the total unique count
total_unique_count=0

# Iterate over the dictionary and replace in the link
for part in "${parts[@]}"; do

    url="https://ci1.netdef.org/browse/FRR-PULLREQ3-${BUILD_NUM}/artifact/${dict[$part]}/AddressSanitizerError/AddressSanitzer.txt"

    echo $part:
    # Perform the curl and grep
    output=$(curl -s "${url}" | grep "Direct leak" -A 3 | grep "#2" | awk '{print $4}')

    if [[ -n "$output" ]]; then
        echo "$output" | sort -u
        unique_count=$(echo "$output" | sort -u | wc -l)
        total_unique_count=$((total_unique_count + unique_count))  # Increment the total unique count

    else
        # If $output is empty, output "[NOTHING]"
        echo "[Nothing]"
    fi

    echo
done

echo "Total unique items across all parts: $total_unique_count"
