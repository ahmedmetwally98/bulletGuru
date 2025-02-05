#!/usr/bin/bash

#########################################################################
#                                                                       #
# This script organizes files in a directory based on their extensions. #
# It moves files to respective directories based on their extensions.   #
#                                                                       #
#########################################################################
# Define styles
BOLD="\e[1m"
RED="\e[31m"
BOLD_READ="\e[1;31m"
RESET="\e[0m"

# $1: directory path
DIR_PATH=$1

# store available extensions
FILES_CATEGORIES=()

# Check if a directory path is provided
if [ -z "$DIR_PATH" ]; then
  echo -e "Usage: $0 $BOLD<directory_path>$RESET"
  exit 1
fi

# Check if the directory exists
if [ ! -d "$DIR_PATH" ]; then
    echo -e "Directory: $BOLD_READ\" $DIR_PATH \"$RESET does not exist"
    exit 1
fi

# Move files to respective directories based on their extensions
# Loop through all files in the directory
for FILE in "$DIR_PATH"/*; do
    # Skip if it's a directory
    if [ -d "$FILE" ]; then
        continue
    fi

    # Get the file name without the path
    FILENAME=$(basename "$FILE")

    # Get the file extension (if any)
    EXTENSION="${FILENAME##*.}"

    # Handle files with no extension or hidden files
    if [[ "$FILENAME" == "$EXTENSION" || "$FILENAME" == .* ]]; then
        EXTENSION="misc"
    fi

    # Create the subdirectory if it doesn't exist
    SUBDIR="$DIR_PATH/$EXTENSION"
    if [ ! -d "$SUBDIR" ]; then
        mkdir -p "$SUBDIR"
    fi

    # Move the file to the appropriate subdirectory
    mv "$FILE" "$SUBDIR/"
    FILES_CATEGORIES+=("$EXTENSION")
done


# Display the files categories
echo -e "Files have been organized into the following categories:"  
for CATEGORY in "${FILES_CATEGORIES[@]}"; do
    echo -e "  $CATEGORY"
done

echo "Files have been organized successfully!"