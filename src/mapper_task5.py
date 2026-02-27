#!/usr/bin/env python3
# Task 5: Law Enforcement Analysis
# Research Question: What percentage of crimes result in an arrest?
# Column: Arrest at index 8 (0-based), values: "true" or "false"
import sys

ARREST_IDX = 8

for line in sys.stdin:
    line = line.strip()

    if not line:
        continue

    parts = line.split(',')

    if len(parts) <= ARREST_IDX:
        continue

    # Skip header row
    if parts[0] == 'ID':
        continue

    arrest_status = parts[ARREST_IDX].strip().lower()

    if arrest_status in ('true', 'false'):
        print(f"{arrest_status}\t1")
