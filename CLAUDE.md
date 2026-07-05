# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A media metadata archival system that catalogs image and video files into a SQLite database. It extracts EXIF metadata (dates, camera info, GPS coordinates, dimensions) using `exiftool`, computes MD5 checksums with Python, and loads everything into SQLite via a CSV staging pipeline.

## Prerequisites

- `exiftool` (for EXIF metadata extraction)
- Python 3 (for MD5 computation)
- SQLite 3
- zsh

## Pipeline Commands

The workflow is a linear 4-step pipeline:

```bash
# 1. Create database schema (run once)
sqlite3 fotos.db < create_tables.sql

# 2. Scan files and enrich with MD5 hashes (piped together)
./getfiles.zsh ~/a/projects/fotos/keep/images | ./add_MD5.py > fotos.csv

# 3. Load into database
sqlite3 fotos.db
.mode csv
.read insert_files.sql
```

Step 2 can also be run separately:
```bash
./getfiles.zsh ~/a/projects/fotos/keep/images > tmp1.csv   # raw exiftool CSV
./add_MD5.py < tmp1.csv > fotos.csv                         # add MD5, split paths
```

## Architecture

**Data flow:** Media files → `getfiles.zsh` (exiftool) → CSV → `add_MD5.py` → enriched CSV → `insert_files.sql` (staging table) → `fotos` table in SQLite

### Scripts

- **getfiles.zsh** — Recursively scans a directory for media files (jpg, jpeg, png, mov, mp4, heic) using `exiftool -f -csv`. The `-f` flag forces columns for missing fields (outputs `-` as placeholder). Outputs CSV to stdout.
- **add_MD5.py** — Reads CSV from stdin, computes actual MD5 hash of each file (64KB buffer), splits `SourceFile` into separate `path` and `filename` columns, writes enriched CSV to stdout. Progress logged to stderr.
- **insert_files.sql** — Creates a 12-column `staging` table (c1–c12), imports `fotos.csv`, INSERTs into `fotos`, then drops staging.
- **create_tables.sql** — Defines the `fotos` table (13 columns including id) and the `actions` view.
- **delete_files.py** — Deletes files listed in a two-column CSV (`path`, `name`). Supports `--dry-run` to preview without deleting. Usage: `python delete_files.py [--dry-run] files.csv`

### Database Schema

**fotos** table: `id`, `path`, `name`, `bytes`, `dt_taken`, `dt_created`, `camera`, `lens`, `lat`, `lon`, `img_size`, `duration`, `md5`

**actions** view: joins `fotos` and `notes` on `fotos.id = notes.fotos_id`, exposing `id`, `path`, `name`, `action`, `category`, `title`. Defined in `create_tables.sql`. Requires a `notes` table (not created by `create_tables.sql` — load from `notes.csv` separately).

### Known Issues

- `create_tables.sql` ends with an orphaned `select * from xxx limit 6;` debug line that causes an error on first run. Remove it before running.
- `create_tables.sql` defines the column as `md5` (lowercase) while `insert_files.sql` references it as `MD5` (uppercase). SQLite is case-insensitive for column names so this works, but standardizing to one casing would be cleaner.
- The `notes` table used by the `actions` view is not created by `create_tables.sql`. It must be created and populated separately (e.g., imported from `notes.csv`).
- exiftool's `-MD5` flag doesn't actually produce MD5 hashes, which is why `add_MD5.py` computes them separately.
