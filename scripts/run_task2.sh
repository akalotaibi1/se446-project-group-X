#!/bin/bash
# Task 2: Crime Type Distribution
# Run this script on the Hadoop cluster

source /etc/profile.d/hadoop.sh

# Delete output dir if it exists (for re-runs)
hdfs dfs -rm -r /user/${USER}/project/m1/task2 2>/dev/null

mapred streaming \
    -files ../src/mapper_task2.py,../src/reducer_sum.py \
    -mapper "python3 mapper_task2.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/${USER}/project/m1/task2

echo "=== Top 10 Crime Types ==="
hdfs dfs -cat /user/${USER}/project/m1/task2/part-00000 | sort -t$'\t' -k2 -rn | head -10
