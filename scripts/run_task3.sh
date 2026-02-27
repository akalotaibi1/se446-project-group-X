#!/bin/bash
# Task 3: Location Hotspots
# Run this script on the Hadoop cluster

source /etc/profile.d/hadoop.sh

# Delete output dir if it exists (for re-runs)
hdfs dfs -rm -r /user/${USER}/project/m1/task3 2>/dev/null

mapred streaming \
    -files ../src/mapper_task3.py,../src/reducer_sum.py \
    -mapper "python3 mapper_task3.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/${USER}/project/m1/task3

echo "=== Top 10 Crime Locations ==="
hdfs dfs -cat /user/${USER}/project/m1/task3/part-00000 | sort -t$'\t' -k2 -rn | head -10
