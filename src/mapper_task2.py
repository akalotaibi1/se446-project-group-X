#!/usr/bin/env python3
# Task 2: Crime Type Distribution
# Research Question: What are the most common types of crimes in Chicago?
# Column: Primary Type at index 5 (0-based)
import sys

PRIMARY_TYPE_IDX = 5

for line in sys.stdin:
    line = line.strip()

    if not line:
        continue

    parts = line.split(',')

    if len(parts) <= PRIMARY_TYPE_IDX:
        continue

    # Skip header row
    if parts[0] == 'ID':
        continue

    crime_type = parts[PRIMARY_TYPE_IDX].strip()

    if crime_type:
        print(f"{crime_type}\t1")
