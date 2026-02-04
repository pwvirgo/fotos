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
./getfiles.zsh ~/a/projects/fotos/images | ./add_MD5.py > tmp2.csv

# 3. Load into database
sqlite3 fotos.db
.mode csv
.read insert_files.sql
```

Steps 2 can also be run separately:
```bash
./getfiles.zsh ~/a/projects/fotos/images > tmp1.csv   # raw exiftool CSV
./add_MD5.py < tmp1.csv > tmp2.csv                     # add MD5, split paths
```

## Architecture

**Data flow:** Media files → `getfiles.zsh` (exiftool) → CSV → `add_MD5.py` → enriched CSV → `insert_files.sql` (staging table) → `fotos` table in SQLite

### Scripts

- **getfiles.zsh** — Recursively scans a directory for media files (jpg, jpeg, png, mov, mp4, heic) using `exiftool -f -csv`. The `-f` flag forces columns for missing fields (outputs `-` as placeholder). Outputs CSV to stdout.
- **add_MD5.py** — Reads CSV from stdin, computes actual MD5 hash of each file (64KB buffer), splits `SourceFile` into separate `path` and `filename` columns, writes enriched CSV to stdout. Progress logged to stderr.
- **insert_files.sql** — Creates a 12-column `staging` table, imports `tmp.csv`, INSERTs into `fotos`, drops staging, and creates the `qui` convenience view.
- **create_tables.sql** — Defines the `fotos` table (13 columns including id) and an incomplete `actions` table.

### Database Schema

**fotos** table: `id`, `path`, `name`, `bytes`, `dt_taken`, `dt_created`, `camera`, `lens`, `lat`, `lon`, `img_size`, `duration`, `MD5`

**actions** table: `id`, `act`, `dt_act`, `note` (has a malformed foreign key reference to fotos)

### Known Issues

- `insert_files.sql` line 27 has a syntax error: `MD5. camera` should be `MD5, camera` in the `qui` view definition.
- The `actions` table has a malformed foreign key declaration (`foriegn key (fotos.id)` instead of proper `FOREIGN KEY` syntax).
- `insert_files.sql` imports from `tmp.csv` but the pipeline outputs `tmp2.csv` — these must match.
- exiftool's `-MD5` flag doesn't actually produce MD5 hashes, which is why `add_MD5.py` computes them separately.
