#!/usr/bin/env python3
"""
Delete files listed in a CSV file.

CSV must have 'path' and 'name' columns (as exported from fotos.db).
Paths are relative to the directory where this script is run.

Usage:
    python delete_files.py files.csv
    python delete_files.py --dry-run files.csv
"""

import csv
import os
import sys


def main():
    args = sys.argv[1:]

    dry_run = '--dry-run' in args
    if dry_run:
        args = [a for a in args if a != '--dry-run']

    if not args:
        print("Usage: python delete_files.py [--dry-run] files.csv")
        sys.exit(1)

    csv_file = args[0]

    if not os.path.exists(csv_file):
        print(f"Error: CSV file not found: {csv_file}")
        sys.exit(1)

    if dry_run:
        print("--- DRY RUN (no files will be deleted) ---")

    deleted = 0
    errors = 0

    with open(csv_file, newline='') as f:
        raw = list(csv.reader(f))

    # Skip header row if present
    if raw and raw[0][0].strip().lower() == 'path':
        raw = raw[1:]

    for cols in raw:
        if len(cols) < 2:
            continue
        filepath = os.path.join(cols[0].strip(), cols[1].strip())
        if True:
            if dry_run:
                exists = os.path.exists(filepath)
                status = "EXISTS" if exists else "NOT FOUND"
                print(f"  [{status}] {filepath}")
                if not exists:
                    errors += 1
                else:
                    deleted += 1
            else:
                try:
                    os.remove(filepath)
                    print(f"  deleted: {filepath}")
                    deleted += 1
                except FileNotFoundError:
                    print(f"  ERROR not found: {filepath}")
                    errors += 1
                except PermissionError:
                    print(f"  ERROR permission denied: {filepath}")
                    errors += 1
                except Exception as e:
                    print(f"  ERROR {filepath}: {e}")
                    errors += 1

    print()
    if dry_run:
        print(f"Would delete: {deleted}  Not found: {errors}")
    else:
        print(f"Deleted: {deleted}  Errors: {errors}")


if __name__ == '__main__':
    main()
