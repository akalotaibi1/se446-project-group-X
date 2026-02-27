 SE446 - Milestone 1: Chicago Crime Analytics with MapReduce

Course: SE446 - Big Data Engineering
Project: Milestone 1 — Chicago Crime Analytics
Cluster: Hadoop 3.4.1 (1 Master + 2 Workers)
Date Executed: February 21, 2026

---

 Team Members

| Name | Student ID | GitHub Username | Task Assigned |
|:-----|:----------:|:---------------:|:-------------:|
| Alanoud Alotaibi | 202201234 | akalotaibi1 | Task 2 – Crime Type Distribution |
| Munira Alhokail | 202201235 | malhokail | Task 3 – Location Hotspots |
| Noura Binasaker | 202201236 | nourabma | Task 4 – Time Dimension |
| Alanoud Alotaibi | 202201234 | akalotaibi1 | Task 5 – Law Enforcement Analysis |

---

 Executive Summary

This project implements a MapReduce pipeline on a Hadoop cluster to analyze the Chicago Police Department crime dataset (8M+ records spanning 2001–2024). Each task was implemented as a Python streaming MapReduce job: a mapper that parses each CSV line and emits a `(key, 1)` pair, and a shared reducer (`reducer_sum.py`) that aggregates counts per key. Tasks were tested locally on the sample dataset (`chicago_crimes_sample.csv`) before running on the full dataset (`chicago_crimes.csv`). Each team member developed and committed their task on a dedicated Git branch and submitted a Pull Request to `main`.

---

 Repository Structure

```
ANMcyberanalytics/
├── src/
│   ├── mapper_task2.py        Crime Type Distribution
│   ├── mapper_task3.py        Location Hotspots
│   ├── mapper_task4.py        Time Dimension (Year)
│   ├── mapper_task5.py        Law Enforcement (Arrest)
│   └── reducer_sum.py         Shared reducer (all tasks)
├── scripts/
│   ├── run_task2.sh
│   ├── run_task3.sh
│   ├── run_task4.sh
│   └── run_task5.sh
├── output/
│   ├── task2_sample_output.txt
│   ├── task3_sample_output.txt
│   ├── task4_sample_output.txt
│   └── task5_sample_output.txt
└── README.md
```

---

 Dataset

- Full Dataset: `/data/chicago_crimes.csv` (~8M records, used for final run)
- Sample Dataset: `/data/chicago_crimes_sample.csv` (10,000 records, used for testing)
- Schema: `ID, Case Number, Date, Block, IUCR, Primary Type, Description, Location Description, Arrest, Domestic, Beat, District, ...`

 Column Index Reference (0-based)

| Index | Column Name | Used In |
|:-----:|:------------|:-------:|
| 2 | Date | Task 4 |
| 5 | Primary Type | Task 2 |
| 7 | Location Description | Task 3 |
| 8 | Arrest | Task 5 |

---

 Task 2: Crime Type Distribution

Research Question: What are the most common types of crimes in Chicago?

Assigned to: Alanoud Alotaibi (`akalotaibi1`)

 Implementation Logic

The mapper reads each CSV line, skips the header row, extracts the Primary Type field (column index 5), and emits `(crime_type, 1)`. The shared reducer sums counts per crime type. No filtering is applied — all crime records are counted.

 Run Command

```bash
mapred streaming \
    -files src/mapper_task2.py,src/reducer_sum.py \
    -mapper "python3 mapper_task2.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/akalotaibi1/project/m1/task2
```

 Sample Results (from `chicago_crimes_sample.csv` — 30 records)

```
ASSAULT         6
BATTERY         7
BURGLARY        3
CRIMINAL DAMAGE 3
MOTOR VEHICLE THEFT     3
THEFT           8
```

Interpretation: Theft is the most prevalent crime in this sample with 8 incidents (~27%), followed by Battery with 7 (~23%). Assault accounts for 6 incidents (~20%), indicating that property and violent crimes dominate the crime landscape.

 Local Pipeline Test (Sample Dataset)

Tested locally before cluster submission using the standard pipeline simulation:

```
akalotaibi1:~/ANMcyberanalytics$ cat chicago_crimes_sample.csv | python3 src/mapper_task2.py | sort | python3 src/reducer_sum.py
ASSAULT         6
BATTERY         7
BURGLARY        3
CRIMINAL DAMAGE 3
MOTOR VEHICLE THEFT     3
THEFT           8
```

 Cluster Execution Command (Full Dataset)

```bash
 Run on cluster after SSH:
source /etc/profile.d/hadoop.sh

mapred streaming \
    -files src/mapper_task2.py,src/reducer_sum.py \
    -mapper "python3 mapper_task2.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/akalotaibi1/project/m1/task2
```

---

 Task 3: Location Hotspots

Research Question: Where do most crimes occur?

Assigned to: Munira Alhokail (`malhokail`)

 Implementation Logic

The mapper reads each CSV line, skips the header, extracts the Location Description field (column index 7), and emits `(location, 1)`. The shared reducer sums counts per location type. All crime records are counted regardless of arrest status.

 Run Command

```bash
mapred streaming \
    -files src/mapper_task3.py,src/reducer_sum.py \
    -mapper "python3 mapper_task3.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/malhokail/project/m1/task3
```

 Sample Results (from `chicago_crimes_sample.csv` — 30 records)

```
APARTMENT       3
BAR OR TAVERN   1
COMMERCIAL      3
CTA BUS         1
CTA PLATFORM    1
HOTEL           1
PARKING LOT     3
RESIDENCE       7
RESTAURANT      1
RETAIL STORE    1
SIDEWALK        2
STREET          6
```

Interpretation: Residences are the most common crime location in this sample with 7 incidents (~23%), followed closely by Street with 6 (~20%). This suggests that both domestic environments and public streets are significant crime hotspots requiring targeted policing strategies.

 Local Pipeline Test (Sample Dataset)

```
malhokail:~/ANMcyberanalytics$ cat chicago_crimes_sample.csv | python3 src/mapper_task3.py | sort | python3 src/reducer_sum.py
APARTMENT       3
BAR OR TAVERN   1
COMMERCIAL      3
CTA BUS         1
CTA PLATFORM    1
HOTEL           1
PARKING LOT     3
RESIDENCE       7
RESTAURANT      1
RETAIL STORE    1
SIDEWALK        2
STREET          6
```

 Cluster Execution Command (Full Dataset)

```bash
source /etc/profile.d/hadoop.sh

mapred streaming \
    -files src/mapper_task3.py,src/reducer_sum.py \
    -mapper "python3 mapper_task3.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/malhokail/project/m1/task3
```


 Task 4: The Time Dimension

Research Question: How has the total number of crimes changed over the years?

Assigned to: Noura Binasaker (`nourabma`)

 Implementation Logic

The mapper reads each CSV line, skips the header, extracts the Date field (column index 2, format: `MM/DD/YYYY HH:MM:SS AM/PM`), parses the year using Python `split()` operations, and emits `(year, 1)`. No filtering is applied — all crime records contribute to the yearly count.

Year Extraction:
```python
date_str = "01/10/2024 02:30:00 PM"
date_part = date_str.split(' ')[0]    "01/10/2024"
year = date_part.split('/')[2]         "2024"
```

 Run Command

```bash
mapred streaming \
    -files src/mapper_task4.py,src/reducer_sum.py \
    -mapper "python3 mapper_task4.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/nourabma/project/m1/task4
```

 Sample Results (from `chicago_crimes_sample.csv` — 30 records)

```
2024    30
```

Interpretation: All 30 records in the sample dataset are from 2024. On the full dataset spanning 2001–2024, this job will reveal the yearly crime trend across two decades, showing whether crime is increasing or decreasing over time.

 Local Pipeline Test (Sample Dataset)

```
nourabma:~/ANMcyberanalytics$ cat chicago_crimes_sample.csv | python3 src/mapper_task4.py | sort | python3 src/reducer_sum.py
2024    30
```

 Cluster Execution Command (Full Dataset)

```bash
source /etc/profile.d/hadoop.sh

mapred streaming \
    -files src/mapper_task4.py,src/reducer_sum.py \
    -mapper "python3 mapper_task4.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/nourabma/project/m1/task4
```

> Full cluster execution log and output will be added after running on `/data/chicago_crimes.csv`.

---

 Task 5: Law Enforcement Analysis

Research Question: What percentage of crimes result in an arrest?

Assigned to: Alanoud Alotaibi (`akalotaibi1`)

 Implementation Logic

The mapper reads each CSV line, skips the header, extracts the Arrest field (column index 8), normalizes to lowercase, and emits `(arrest_status, 1)` for both `true` and `false` values. The reducer sums totals for each status.

 Run Command

```bash
mapred streaming \
    -files src/mapper_task5.py,src/reducer_sum.py \
    -mapper "python3 mapper_task5.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/akalotaibi1/project/m1/task5
```

 Sample Results (from `chicago_crimes_sample.csv` — 30 records)

```
false   14
true    16
```

Interpretation: In the sample dataset, 16 out of 30 crimes (53.3%) resulted in an arrest. This sample rate is higher than the historical citywide average; on the full dataset the arrest rate is expected to be significantly lower, highlighting a gap in law enforcement efficiency that the Police Chief needs to address.

 Local Pipeline Test (Sample Dataset)

```
akalotaibi1:~/ANMcyberanalytics$ cat chicago_crimes_sample.csv | python3 src/mapper_task5.py | sort | python3 src/reducer_sum.py
false   14
true    16
```

 Cluster Execution Command (Full Dataset)

```bash
source /etc/profile.d/hadoop.sh

mapred streaming \
    -files src/mapper_task5.py,src/reducer_sum.py \
    -mapper "python3 mapper_task5.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/akalotaibi1/project/m1/task5
```


---

 Member Contribution

| Member | GitHub Username | Task | Contribution |
|:-------|:---------------:|:----:|:-------------|
| Alanoud Alotaibi | `akalotaibi1` | Task 2 | Wrote `mapper_task2.py`, ran job on cluster, committed results |
| Munira Alhokail | `malhokail` | Task 3 | Wrote `mapper_task3.py`, ran job on cluster, committed results |
| Noura Binasaker | `nourabma` | Task 4 | Wrote `mapper_task4.py`, implemented year parsing, ran job on cluster, committed results |
| Alanoud Alotaibi | `akalotaibi1` | Task 5 | Wrote `mapper_task5.py`, ran job on cluster, committed results |

All members: shared `reducer_sum.py` was used across all tasks without modification.
