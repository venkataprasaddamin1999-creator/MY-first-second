#!/bin/bash

################################################################################
# VM Health Check Script
# 
# Purpose: Analyze the health of a virtual machine based on:
#          - CPU utilization
#          - Memory utilization
#          - Disk space utilization
#
# Health Status:
#          - HEALTHY: All parameters are below 60% utilization
#          - NOT HEALTHY: Any parameter exceeds 60% utilization
#
# Usage: ./vm_health_check.sh [--explain]
#        ./vm_health_check.sh [explain]
#
# Arguments:
#          --explain or explain: Display detailed explanation of health status
#
# Author: System Administrator
# Date: 2026
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Threshold percentage
THRESHOLD=60

# Initialize variables
CPU_USAGE=0
MEMORY_USAGE=0
DISK_USAGE=0
HEALTH_STATUS="HEALTHY"
EXPLAIN_FLAG=false

################################################################################
# Function: Get CPU Utilization
# Description: Calculates the average CPU utilization over the last minute
# Returns: CPU usage percentage
################################################################################
get_cpu_usage() {
    local cpu_usage
    
    # Using top command with batch mode to get CPU usage
    # The approach: get idle percentage and subtract from 100
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    
    # Round to nearest integer
    cpu_usage=$(printf "%.0f" "$cpu_usage")
    
    echo "$cpu_usage"
}

################################################################################
# Function: Get Memory Utilization
# Description: Calculates the total memory utilization percentage
# Returns: Memory usage percentage
################################################################################
get_memory_usage() {
    local memory_usage
    
    # Using free command to get memory usage
    # Formula: (Used Memory / Total Memory) * 100
    memory_usage=$(free | grep Mem | awk '{printf("%.0f", ($3 / $2) * 100)}')
    
    echo "$memory_usage"
}

################################################################################
# Function: Get Disk Utilization
# Description: Calculates the root filesystem (/) disk utilization percentage
# Returns: Disk usage percentage
################################################################################
get_disk_usage() {
    local disk_usage
    
    # Using df command to get disk usage for root filesystem
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo "$disk_usage"
}

################################################################################
# Function: Determine Health Status
# Description: Determines if VM is healthy based on utilization thresholds
# Returns: None (sets HEALTH_STATUS global variable)
################################################################################
determine_health_status() {
    HEALTH_STATUS="HEALTHY"
    
    if (( CPU_USAGE > THRESHOLD )); then
        HEALTH_STATUS="NOT HEALTHY"
    fi
    
    if (( MEMORY_USAGE > THRESHOLD )); then
        HEALTH_STATUS="NOT HEALTHY"
    fi
    
    if (( DISK_USAGE > THRESHOLD )); then
        HEALTH_STATUS="NOT HEALTHY"
    fi
}

################################################################################
# Function: Display Health Status
# Description: Displays the health status in a formatted manner
# Returns: None
################################################################################
display_health_status() {
    local status_color
    
    if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
        status_color="$GREEN"
    else
        status_color="$RED"
    fi
    
    echo ""
    echo "==============================================="
    echo "         VM HEALTH CHECK REPORT"
    echo "==============================================="
    echo -e "CPU Utilization:     $CPU_USAGE%"
    echo -e "Memory Utilization:  $MEMORY_USAGE%"
    echo -e "Disk Utilization:    $DISK_USAGE%"
    echo "-----------------------------------------------"
    echo -e "Status: ${status_color}${HEALTH_STATUS}${NC}"
    echo "==============================================="
    echo ""
}

################################################################################
# Function: Display Detailed Explanation
# Description: Displays detailed explanation of health status with reasons
# Returns: None
################################################################################
display_explanation() {
    local cpu_status="GOOD"
    local memory_status="GOOD"
    local disk_status="GOOD"
    
    echo ""
    echo "==============================================="
    echo "    VM HEALTH CHECK DETAILED REPORT"
    echo "==============================================="
    echo ""
    
    # CPU Analysis
    echo "CPU ANALYSIS:"
    if (( CPU_USAGE > THRESHOLD )); then
        cpu_status="CRITICAL"
        echo -e "  ${RED}[CRITICAL]${NC} CPU usage is ${RED}${CPU_USAGE}%${NC}"
        echo "  Reason: CPU utilization exceeds threshold of ${THRESHOLD}%"
        echo "  Recommendation: Investigate running processes, consider:"
        echo "    - Use 'top' or 'htop' to identify high CPU processes"
        echo "    - Optimize heavy applications"
        echo "    - Consider vertical scaling (more CPU cores)"
    else
        echo -e "  ${GREEN}[GOOD]${NC} CPU usage is ${GREEN}${CPU_USAGE}%${NC}"
        echo "  Reason: CPU utilization is below threshold of ${THRESHOLD}%"
    fi
    echo ""
    
    # Memory Analysis
    echo "MEMORY ANALYSIS:"
    if (( MEMORY_USAGE > THRESHOLD )); then
        memory_status="CRITICAL"
        echo -e "  ${RED}[CRITICAL]${NC} Memory usage is ${RED}${MEMORY_USAGE}%${NC}"
        echo "  Reason: Memory utilization exceeds threshold of ${THRESHOLD}%"
        echo "  Recommendation: Investigate memory consumption, consider:"
        echo "    - Use 'free -h' to view memory distribution"
        echo "    - Use 'ps aux' to identify high memory processes"
        echo "    - Check for memory leaks in applications"
        echo "    - Consider horizontal scaling or memory optimization"
    else
        echo -e "  ${GREEN}[GOOD]${NC} Memory usage is ${GREEN}${MEMORY_USAGE}%${NC}"
        echo "  Reason: Memory utilization is below threshold of ${THRESHOLD}%"
    fi
    echo ""
    
    # Disk Analysis
    echo "DISK ANALYSIS:"
    if (( DISK_USAGE > THRESHOLD )); then
        disk_status="CRITICAL"
        echo -e "  ${RED}[CRITICAL]${NC} Disk usage is ${RED}${DISK_USAGE}%${NC}"
        echo "  Reason: Disk utilization exceeds threshold of ${THRESHOLD}%"
        echo "  Recommendation: Free up disk space, consider:"
        echo "    - Use 'du -sh /*' to identify large directories"
        echo "    - Clean up old logs: 'sudo journalctl --vacuum=7d'"
        echo "    - Remove unused packages: 'sudo apt-get autoremove'"
        echo "    - Clean package cache: 'sudo apt-get clean'"
        echo "    - Consider expanding disk capacity"
    else
        echo -e "  ${GREEN}[GOOD]${NC} Disk usage is ${GREEN}${DISK_USAGE}%${NC}"
        echo "  Reason: Disk utilization is below threshold of ${THRESHOLD}%"
    fi
    echo ""
    
    # Overall Status
    echo "-----------------------------------------------"
    local status_color
    if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
        status_color="$GREEN"
    else
        status_color="$RED"
    fi
    echo -e "Overall Status: ${status_color}${HEALTH_STATUS}${NC}"
    echo "==============================================="
    echo ""
}

################################################################################
# Function: Display Usage
# Description: Displays script usage information
# Returns: None
################################################################################
display_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --explain, explain    Display detailed explanation of health status"
    echo "  --help, -h, help      Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0                      # Display basic health status"
    echo "  $0 --explain           # Display health status with detailed explanation"
    echo "  $0 explain             # Same as above"
    echo ""
}

################################################################################
# Main Script Execution
################################################################################

# Parse command line arguments
for arg in "$@"; do
    case "$arg" in
        --explain|explain)
            EXPLAIN_FLAG=true
            ;;
        --help|-h|help)
            display_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown argument '$arg'"
            display_usage
            exit 1
            ;;
    esac
done

# Collect system metrics
echo "Analyzing VM health..."
CPU_USAGE=$(get_cpu_usage)
MEMORY_USAGE=$(get_memory_usage)
DISK_USAGE=$(get_disk_usage)

# Determine health status
determine_health_status

# Display results based on arguments
display_health_status

if [ "$EXPLAIN_FLAG" = true ]; then
    display_explanation
fi

# Exit with appropriate code
if [ "$HEALTH_STATUS" = "HEALTHY" ]; then
    exit 0
else
    exit 1
fi