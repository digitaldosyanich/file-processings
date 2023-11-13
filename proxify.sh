#!/bin/bash

# Check if a TSV file is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <TSV_FILE>"
    exit 1
fi

# Get the TSV file from the command line
TSV_FILE="$1"
TSV_DIR=$(dirname "$TSV_FILE")

# Function to create directories
create_directories() {
    while IFS=$'\t' read -r _ _ path _; do
        sanitized_path="${path//\"/}"  # Remove quotes from the path
        mkdir -p "$TSV_DIR/$sanitized_path"
    done < "$TSV_FILE"
}

# Function to create empty files
create_empty_files() {
    while IFS=$'\t' read -r _ _ path filename _ _; do
        sanitized_path="${path//\"/}"  # Remove quotes from the path
        touch "$TSV_DIR/$sanitized_path/$filename"
    done < "$TSV_FILE"
}

# Main execution
create_directories
create_empty_files

echo "Proxy folders and empty files created based on the TSV file in the same directory."
