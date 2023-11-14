#!/bin/bash

# Function to rename MP3 files in a folder and its subfolders
function rename_files {
    local input_folder="$1"
    local rename_list=()

    # Collect MP3 files in the input folder
    for mp3_file in "$input_folder"/*.mp3; do
        if [ -f "$mp3_file" ]; then
            file_name=$(basename "$mp3_file")
            file_extension="${file_name##*.}"
            new_file_name=$(printf "%03d.%s" "${file_name%%.*}" "$file_extension")
            rename_list+=("$mp3_file" "$input_folder/$new_file_name")
        fi
    done

    # Ask for confirmation before renaming
    if [ ${#rename_list[@]} -gt 0 ]; then
        echo "MP3 files in '$input_folder' to be renamed:"
        for ((i = 0; i < ${#rename_list[@]}; i += 2)); do
            echo "Source: ${rename_list[i]}"
            echo "Target: ${rename_list[i + 1]}"
        done

        read -p "Do you want to rename the MP3 files? (y/n): " rename_confirmation

        if [ "$rename_confirmation" == "y" ]; then
            for ((i = 0; i < ${#rename_list[@]}; i += 2)); do
                mv "${rename_list[i]}" "${rename_list[i + 1]}"
            done
            echo "Renamed MP3 files in '$input_folder'."
        fi
    fi
}

# Function to merge MP3 files in a folder and its subfolders
function merge_subfolders {
    local input_folder="$1"
    local output_folder="$2"
    local target_files=()

    # Collect target MP3 files in the input folder
    for mp3_file in "$input_folder"/*.mp3; do
        if [ -f "$mp3_file" ]; then
            target_files+=("$mp3_file")
        fi
    done

    # Display a list of target MP3 files
    echo "Target MP3 files in '$input_folder':"
    for file in "${target_files[@]}"; do
        echo "$file"
    done

    # Ask for confirmation before merging
    read -p "Do you want to merge the above MP3 files? (y/n): " merge_confirmation

    if [ "$merge_confirmation" != "y" ]; then
        echo "Merging canceled for '$input_folder'."
    else
        # Create the output folder if it doesn't exist
        mkdir -p "$output_folder"

        # Merge all AIFF files in the input folder into the output file using sox
        # sox "${target_files[@]}" "$output_folder/$(basename "$input_folder").mp3"
		
		
		# Merge all MP3 files in the input folder into the output file using cat
		# cat "${target_files[@]}" > "$output_folder/$(basename "$input_folder").mp3"

		# Merge all MP3 files in the input folder into the output file using ffmpeg (overwrite without asking)
		ffmpeg -y -i "concat:$(IFS=\|; echo "${target_files[*]}")" -acodec copy "$output_folder/$(basename "$input_folder").mp3"




        echo "Merged files in '$input_folder' into '$output_folder/$(basename "$input_folder").mp3'"

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
