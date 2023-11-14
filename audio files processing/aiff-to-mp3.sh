#!/bin/bash

# Check if a custom path is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/AIFF_FOLDER"
    exit 1
fi

# Store the custom path provided as an argument
aiff_folder="$1"

# Verify that the provided path exists and is a directory
if [ ! -d "$aiff_folder" ]; then
    echo "Error: '$aiff_folder' is not a valid directory."
    exit 1
fi

# Convert AIFF files to MP3 in parallel
find "$aiff_folder" -type f -name "*.aiff" | parallel -j10 ffmpeg -i {} -acodec libmp3lame -q:a 2 {.}.mp3
