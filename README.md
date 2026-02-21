# fotos database  2026-02-02

Create a db of image files - names, dates, exif info

## execution instructions
using sqlite3

1. create tables:  create_tables.sql 

2. create csv file (using exiftools in zsh script) 
	and then add MD5 column to the csv using python

	./getfiles.zsh ~/a/projects/fotos/keep/images | ./add_MD5.py > fotos.csv

3. populate the database

	-	modify insert_files.sql to reference csv file from step 2
	-	sqlite3 foto.db
	-	.read insert_files.sql


## files:
-rwxr-xr-x@  add_MD5.py
-rw-r--r--@  create_tables.sql
-rw-r--r--   fotos.db
-rwxr-xr-x@  getfiles.zsh
-rw-r--r--@  insert_files.sql
-rw-r--r--@  README.md



## notes
This is taking a long time but I hope to get good at it

Gemini taught me about exiftool and got things working in zsh

the exiftool was not creating a column for requested data if that item
was not in any of the files it processed  add -f to force the issue.
Now returns a column with '-' for each row. 

claude code helped to write the modules

use python to create MD5 hash because the exiftool fails to do that
