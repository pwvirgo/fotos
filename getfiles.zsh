#!/bin/zsh

# Check if a directory was provided; if not, use the current directory ('.')
TARGET_DIR="${1:-.}"

# Check if the provided path is actually a directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: $TARGET_DIR is not a valid directory."
    exit 1
fi

exiftool -f -csv -r -d "%Y-%m-%d %H:%M:%S" \
-MD5 -FileSize# -DateTimeOriginal -CreateDate \
-Model -LensID -GPSLatitude# -GPSLongitude# -ImageSize -Duration \
-ext jpg -ext jpeg -ext png -ext mov -ext mp4 -ext heic \
"$TARGET_DIR"
