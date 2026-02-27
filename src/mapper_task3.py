#!/usr/bin/env python3
# Task 3: Location Hotspots
# Research Question: Where do most crimes occur?
# Column: Location Description at index 7 (0-based)
import sys

LOCATION_IDX = 7

for line in sys.stdin:
    line = line.strip()

    if not line:
        continue

    parts = line.split(',')

    if len(parts) <= LOCATION_IDX:
        continue

    # Skip header row
    if parts[0] == 'ID':
        continue

    location = parts[LOCATION_IDX].strip()

    if location:
        print(f"{location}\t1")
