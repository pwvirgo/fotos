#!/usr/bin/env python3
import csv
import hashlib
import os
import sys

def get_md5(file_path):
    if not os.path.exists(file_path):
        return ""
    hash_md5 = hashlib.md5()
    try:
        # Using a 64KB buffer for better performance on larger media files
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                hash_md5.update(chunk)
        return hash_md5.hexdigest()
    except Exception:
        return "ERROR"

def main():
    # Read from standard input
    reader = csv.DictReader(sys.stdin)
    
    if not reader.fieldnames:
        return

    # Prepare new fieldnames: 
    # Remove 'SourceFile', add 'Directory', 'Filename', and 'MD5'
    new_fields = ['path', 'filename'] + [f for f in reader.fieldnames if f != 'SourceFile']
    if 'MD5' not in new_fields:
        new_fields.append('MD5')

    # Write to standard output
    writer = csv.DictWriter(sys.stdout, fieldnames=new_fields)
    writer.writeheader()
    once = False
    for row in reader:
        original_path = row.get('SourceFile', '')
        if not once:
            sys.stderr.write(f"Processing: {original_path} and then all the rest\n")
        once = True

        if original_path:
            #sys.stderr.write(f"Processing: {original_path}\n")
            
            # Split path into directory and filename
            directory, filename = os.path.split(original_path)
            
            # Populate new columns
            row['path'] = directory
            row['filename'] = filename
            row['MD5'] = get_md5(original_path)
            
            # Remove the old combined column before writing
            del row['SourceFile']
            
            writer.writerow(row)

if __name__ == "__main__":
    main()
