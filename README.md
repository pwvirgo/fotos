# fotos database  2026-02-02

Create a db of meta data about image files - names, dates, exif info

(This is to be used with other apps to select, track, rename, document)

## execution instructions
using sqlite3

1. create tables:  `sqlite3 fotos.db < create_tables.sql`

2. scan files and compute MD5 hashes:

	`./getfiles.zsh ~/a/projects/fotos/keep/images | ./add_MD5.py > fotos.csv`

3. populate the database:

	```
	sqlite3 fotos.db
	.read insert_files.sql
	```

See CLAUDE.md for full technical reference, architecture details, and known issues.


## files:
- `getfiles.zsh` — scans media files with exiftool, outputs CSV
- `add_MD5.py` — reads CSV from stdin, adds MD5 column, writes to stdout
- `delete_files.py` — deletes files listed in a CSV (supports --dry-run)
- `create_tables.sql` — creates the fotos table and actions view
- `insert_files.sql` — loads fotos.csv into the database
- `fotos.db` — the SQLite database



## notes
This is taking a long time but I hope to get good at it

Gemini taught me about exiftool and got things working in zsh

the exiftool was not creating a column for requested data if that item
was not in any of the files it processed  add -f to force the issue.
Now returns a column with '-' for each row. 

claude code helped to write the modules

use python to create MD5 hash because the exiftool fails to do that
