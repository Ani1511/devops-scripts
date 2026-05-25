#!/bin/bash

# ============================================
# System Health Monitor
# Author: Aniket Gole
# Description: Monitors CPU, Memory, Disk
#              usage and logs the report
# ============================================

LOG_FILE="health_report.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "============================================"
echo " System Health Report"
echo " Generated on: $DATE"
echo "============================================"

# CPU Usage
echo ""
echo "--- CPU Usage ---"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "CPU Usage: $CPU_USAGE%"

# Memory Usage
echo ""
echo "--- Memory Usage ---"
TOTAL_MEM=$(free -m | awk '/Mem:/ {print $2}')
USED_MEM=$(free -m | awk '/Mem:/ {print $3}')
FREE_MEM=$(free -m | awk '/Mem:/ {print $4}')
echo "Total Memory : ${TOTAL_MEM} MB"
echo "Used Memory  : ${USED_MEM} MB"
echo "Free Memory  : ${FREE_MEM} MB"

# Disk Usage
echo ""
echo "--- Disk Usage ---"
df -h | grep -E '^/dev/' | awk '{print "Mount: "$6" | Total: "$2" | Used: "$3" | Free: "$4" | Usage: "$5}'

# Top 5 CPU Consuming Processes
echo ""
echo "--- Top 5 CPU Consuming Processes ---"
ps aux --sort=-%cpu | awk 'NR<=6{printf "%-10s %-8s %-8s %s\n", $1, $2, $3, $11}' | head -6

# Top 5 Memory Consuming Processes
echo ""
echo "--- Top 5 Memory Consuming Processes ---"
ps aux --sort=-%mem | awk 'NR<=6{printf "%-10s %-8s %-8s %s\n", $1, $2, $4, $11}' | head -6

# System Uptime
echo ""
echo "--- System Uptime ---"
uptime

# Log the report
echo "$DATE - CPU: $CPU_USAGE% | RAM Used: $USED_MEM MB / $TOTAL_MEM MB" >> $LOG_FILE
echo ""
echo "Report saved to $LOG_FILE"
echo "============================================"
