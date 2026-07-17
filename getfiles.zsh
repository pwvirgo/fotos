#!/bin/zsh
# find all image files in the folder specified on the command line
# and output their names, paths, metadata, md5 Hashes to stdout in CSV format
# using exiftool

# Check if a directory was provided; if not, use the current directory ('.')
TARGET_DIR="${1:-.}"

# Check if the provided path is actually a directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: $TARGET_DIR is not a valid directory."
    exit 1
fi

exiftool -f -sort -csv -r -d "%Y-%m-%d %H:%M:%S" \
-FileSize# -DateTimeOriginal -CreateDate \
-Model -LensID -GPSLatitude# -GPSLongitude# -ImageSize -Duration \
-ext jpg -ext jpeg -ext png -ext mov -ext mp4 -ext heic \
"$TARGET_DIR"
