#!/bin/bash

# usage note: give the exec permission to scrips

# Check if the text file exists
if [ ! -f "folders.txt" ]; then
    echo "Error: 'folders.txt' not found."
    exit 1
fi

# Create a folder to store the newly created folders
output_folder="new-folders"
mkdir -p "$output_folder"

# Read each line from the text file and create a folder
while IFS= read -r folder_name; do
    if [ -n "$folder_name" ]; then
        # Replace ":" and "?" with " - " and remove other dangerous symbols
        safe_folder_name=$(echo "$folder_name" | tr -d -C '[:alnum:]-!. ')
        safe_folder_name=$(echo "$safe_folder_name" | sed 's/[:?]/ - /g')

        # Create the folder in the output folder
        mkdir "$output_folder/$safe_folder_name"
        echo "Created folder: $output_folder/$safe_folder_name"
    fi
done < "folders.txt"

echo "Folders created successfully in '$output_folder'."
