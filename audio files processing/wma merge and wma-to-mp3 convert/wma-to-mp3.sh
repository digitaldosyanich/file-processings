#!/bin/bash

# Check if a custom path is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/WMA_CATALOG"
    exit 1
fi

# Store the custom path provided as an argument
wma_path="$1"

# Verify that the provided path exists and is a directory
if [ ! -d "$wma_path" ]; then
    echo "Error: '$wma_path' is not a valid directory."
    exit 1
fi

# Determine the output folder path for MP3 files
output_folder="$wma_path/MP3_CATALOG"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Convert all WMA files in the input folder to MP3 using ffmpeg
find "$wma_path" -type f -name "*.wma" -print0 | while IFS= read -r -d '' wma_file; do
    mp3_file="$output_folder/$(basename "${wma_file%.wma}.mp3")"
    ffmpeg -y -i "$wma_file" -acodec libmp3lame -q:a 0 "$mp3_file"
    echo "Converted '$wma_file' to '$mp3_file'"
done

echo "Conversion complete."
