#!/bin/bash
# Task 5: Arrest Rate Analysis
# Run this script on the Hadoop cluster

source /etc/profile.d/hadoop.sh

# Delete output dir if it exists (for re-runs)
hdfs dfs -rm -r /user/${USER}/project/m1/task5 2>/dev/null

mapred streaming \
    -files ../src/mapper_task5.py,../src/reducer_sum.py \
    -mapper "python3 mapper_task5.py" \
    -reducer "python3 reducer_sum.py" \
    -input /data/chicago_crimes.csv \
    -output /user/${USER}/project/m1/task5

echo "=== Arrest Status Breakdown ==="
hdfs dfs -cat /user/${USER}/project/m1/task5/part-00000
