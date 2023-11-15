#!/bin/bash

# Function to rename WMA files in a folder and its subfolders
function rename_files {
    local input_folder="$1"
    local rename_list=()

    # Collect WMA files in the input folder
    local wma_files=()
    while IFS= read -r -d '' wma_file; do
        wma_files+=("$wma_file")
    done < <(find "$input_folder" -maxdepth 1 -type f -name '*.wma' -print0 | sort -zV)

    for ((i = 0; i < ${#wma_files[@]}; i++)); do
        wma_file="${wma_files[i]}"
        file_name=$(basename "$wma_file")
        file_extension="${file_name##*.}"
        new_file_name=$(printf "%03d.%s" "$((i + 1))" "$file_extension")
        rename_list+=("$wma_file" "$input_folder/$new_file_name")
    done

    # Ask for confirmation before renaming
    if [ ${#rename_list[@]} -gt 0 ]; then
        echo "WMA files in '$input_folder' to be renamed:"
        for ((i = 0; i < ${#rename_list[@]}; i += 2)); do
            echo "Source: ${rename_list[i]}"
            echo "Target: ${rename_list[i + 1]}"
        done

        read -p "Do you want to rename the WMA files? (y/n): " rename_confirmation

        if [ "$rename_confirmation" == "y" ]; then
            for ((i = 0; i < ${#rename_list[@]}; i += 2)); do
                mv "${rename_list[i]}" "${rename_list[i + 1]}"
            done
            echo "Renamed WMA files in '$input_folder'."
        fi
    fi
}


# Function to merge WMA files in a folder and its subfolders
function merge_subfolders {
    local input_folder="$1"
    local output_folder="$2"
    local target_files=()

    # Collect target WMA files in the input folder
    for wma_file in "$input_folder"/*.wma; do
        if [ -f "$wma_file" ]; then
            target_files+=("$wma_file")
        fi
    done

    # Display a list of target WMA files
    echo "Target WMA files in '$input_folder':"
    for file in "${target_files[@]}"; do
        echo "$file"
    done

    # Ask for confirmation before merging
    read -p "Do you want to merge the above WMA files? (y/n): " merge_confirmation

    if [ "$merge_confirmation" != "y" ]; then
        echo "Merging canceled for '$input_folder'."
    else
        # Create the output folder if it doesn't exist
        mkdir -p "$output_folder"

        # Generate a temporary text file containing the list of input files
        temp_list_file=$(mktemp)
        printf "file '%s'\n" "${target_files[@]}" > "$temp_list_file"

        # Merge all WMA files in the input folder into the output file using ffmpeg (overwrite without asking)
        ffmpeg -y -f concat -safe 0 -i "$temp_list_file" -c copy "$output_folder/$(basename "$input_folder").wma"

        # Remove the temporary list file
        rm -f "$temp_list_file"

        echo "Merged files in '$input_folder' into '$output_folder/$(basename "$input_folder").wma'"

        # Recursively process subfolders
        for folder in "$input_folder"/*/; do
            if [ -d "$folder" ]; then
                merge_subfolders "$folder" "$output_folder"
            fi
        done
    fi
}



# Check if a custom path is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/ROOT_CATALOG"
    exit 1
fi

# Store the custom path provided as an argument
custom_path="$1"

# Verify that the provided path exists and is a directory
if [ ! -d "$custom_path" ]; then
    echo "Error: '$custom_path' is not a valid directory."
    exit 1
fi

# Determine the output folder path (e.g., MERGED_CATALOG or use the folder name)
output_folder="$custom_path/MERGED_CATALOG"

# Iterate through first-level subfolders in the custom path
for subfolder in "$custom_path"/*/; do
    if [ -d "$subfolder" ]; then
        rename_files "$subfolder"
        merge_subfolders "$subfolder" "$output_folder"
    fi
done
