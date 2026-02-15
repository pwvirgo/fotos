# fotos database  2026-02-02

Create a db of image files - names, dates, exif info

## execution instructions
using sqlite3

1. create tables:  create_tables.sql 

2. find files (Requires exiftool)

./getfiles.zsh ~/a/projects/fotos/images > tmp1.csv

3. add MD5 hash of file contents, split path and filename

./add_MD5.py < tmp1.csv > tmp2.csv

4. put 2 & 3 together

./getfiles.zsh ~/a/projects/fotos/images | ./add_MD5.py > tmp2.csv

5. populate the database

sqlite3 foto.db
.mode csv
.read insert_files.sql


## files:
-rwxr-xr-x@  add_MD5.py
-rw-r--r--@  create_tables.sql
-rw-r--r--   fotos.db
-rwxr-xr-x@  getfiles.zsh
-rw-r--r--@  insert_files.sql
-rw-r--r--@  README.md


This is taking a long time but I hope to get good at it

## notes
Gemini taught me about exiftool and got things working

the exiftool was not creating a column for requested data if that item
was not in any of the files it processed  add -f to force the issue.
Now returns a column with '-' for each row. 

use python to create MD5 hash because the exiftool fails to do that
