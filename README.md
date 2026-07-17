# fotos database  2026-02-02

# do not DELETE the Keep folder!

This software is used to populate a database of info about my photos.  The Keep folder includes the images/videos those I had backed up to pwv_repo an  external ssd.  There are many more - especially in google photos.

The copies of the images and the db are in the Keep folder.  Both this imac and the pwv_repo are backed up each night to idrive.

 I intend to REPLACE the photos on pwv_repo after curatioan and organization.  There are more photos around that will one day be added to this new repository.

Create a db of meta data about image files - names, dates, exif info

## execution instructions - how it was done.

1. copy the the images from pwv_repo to the Keep/images folder
	`copyImages.zsh` 
	WARNING: !!!!!  these are the new offical images - edited 
	CAUTION: folders are hardcoded relative paths.

2. scan files and compute MD5 hashes save results a csv file:
    WARNING!!!
	`./getfiles.zsh ~/a/projects/fotos/Keep/images | ./add_MD5.py > fotos.csv`

3. using sqlite3
	- create tables:  `sqlite3 fotos2.db < create_tables.sql`

	- populate the database:

	```
		sqlite3 fotos2.db
		.read insert_files.sql
	```

See CLAUDE.md for full technical reference, architecture details, and known issues.


## files:
- `getfiles.zsh` — scans media files with exiftool, outputs CSV
- `add_MD5.py` — reads CSV from stdin, adds MD5 column, writes to stdout
- `delete_files.py` — deletes files listed in a CSV (supports --dry-run)
- `create_tables.sql` — creates the fotos, notes, and actions tables
- `insert_files.sql` — loads fotos.csv into the database
- `query/compare_tables.sql` — compares fotos rows between the new db and an attached old fotos.db
- `fotos.db` — the SQLite database



## notes
This is taking a long time but I hope to get good at it

Gemini taught me about exiftool and got things working in zsh

the exiftool was not creating a column for requested data if that item
was not in any of the files it processed  add -f to force the issue.
Now returns a column with '-' for each row. 

claude code helped to write the modules

use python to create MD5 hash because the exiftool fails to do that
