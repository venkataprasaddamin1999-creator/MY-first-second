# VM Health Check Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Bash script for monitoring the health of Ubuntu virtual machines. The script analyzes system resources based on CPU, memory, and disk space utilization.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Health Metrics](#health-metrics)
- [Output Examples](#output-examples)
- [Automation & Integration](#automation--integration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

The VM Health Check Script provides a simple yet comprehensive way to monitor the health status of Ubuntu virtual machines. It evaluates three critical system metrics and determines overall VM health based on resource utilization thresholds.

### Health Determination Logic

- **HEALTHY**: All metrics (CPU, Memory, Disk) are below 60% utilization
- **NOT HEALTHY**: Any metric exceeds 60% utilization

This 60% threshold is a conservative measure to ensure your VM has sufficient headroom for peak loads and sudden spikes in resource consumption.

## Features

✅ **Three Core Metrics**
- Real-time CPU utilization analysis
- Memory consumption tracking
- Disk space usage monitoring

✅ **Flexible Output Modes**
- Basic mode: Quick health status overview
- Explain mode: Detailed diagnostics with actionable recommendations

✅ **Command-Line Argument Support**
- `--explain` or `explain`: Show detailed analysis with troubleshooting steps
- `--help`: Display usage information

✅ **Production-Ready Features**
- Color-coded output (green/red) for quick visual assessment
- Proper exit codes (0 for healthy, 1 for not healthy)
- Integration-ready for automation tools
- Well-commented and documented code

✅ **Troubleshooting Guidance**
- Detailed recommendations for each component
- Common remediation steps
- Performance optimization suggestions

## System Requirements

- **Operating System**: Ubuntu Linux (or Ubuntu-based distributions)
- **Bash Version**: 4.0 or higher
- **Required Commands**: `top`, `free`, `df`, `awk`, `sed`, `grep`
- **Permissions**: User permissions (no sudo required for data collection)
- **Optional**: `htop` for advanced monitoring (mentioned in recommendations)

### Supported Ubuntu Versions

- Ubuntu 18.04 LTS
- Ubuntu 20.04 LTS
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS
- Other Ubuntu-based distributions (Debian, Linux Mint, etc.)

## Installation

### Method 1: Clone the Repository

```bash
git clone https://github.com/venkataprasaddamin1999-creator/MY-first-second.git
cd MY-first-second
chmod +x vm_health_check.sh
```

### Method 2: Download and Set Up

```bash
# Download the script
wget https://raw.githubusercontent.com/venkataprasaddamin1999-creator/MY-first-second/main/vm_health_check.sh

# Make it executable
chmod +x vm_health_check.sh
```

### Method 3: Copy to System Path (Optional)

To run the script from anywhere on your system:

```bash
sudo cp vm_health_check.sh /usr/local/bin/vm-health-check
sudo chmod +x /usr/local/bin/vm-health-check

# Now you can run it from anywhere
vm-health-check
```

## Usage

### Basic Usage

Display the VM health status with current resource utilization:

```bash
./vm_health_check.sh
```

**Output:**
```
Analyzing VM health...

===============================================
         VM HEALTH CHECK REPORT
===============================================
CPU Utilization:     35%
Memory Utilization:  52%
Disk Utilization:    48%
-----------------------------------------------
Status: HEALTHY
===============================================
```

### Detailed Analysis Mode

Display comprehensive health analysis with explanations and recommendations:

```bash
# Using --explain flag
./vm_health_check.sh --explain

# Or simply use 'explain' as argument
./vm_health_check.sh explain
```

**Output Sample:**
```
===============================================
    VM HEALTH CHECK DETAILED REPORT
===============================================

CPU ANALYSIS:
  [GOOD] CPU usage is 35%
  Reason: CPU utilization is below threshold of 60%

MEMORY ANALYSIS:
  [GOOD] Memory usage is 52%
  Reason: Memory utilization is below threshold of 60%

DISK ANALYSIS:
  [CRITICAL] Disk usage is 78%
  Reason: Disk utilization exceeds threshold of 60%
  Recommendation: Free up disk space, consider:
    - Use 'du -sh /*' to identify large directories
    - Clean up old logs: 'sudo journalctl --vacuum=7d'
    - Remove unused packages: 'sudo apt-get autoremove'
    - Clean package cache: 'sudo apt-get clean'
    - Consider expanding disk capacity

-----------------------------------------------
Overall Status: NOT HEALTHY
===============================================
```

### Help Command

Display usage information:

```bash
./vm_health_check.sh --help
./vm_health_check.sh -h
./vm_health_check.sh help
```

## Health Metrics

### 1. CPU Utilization

**What it measures**: The percentage of CPU resources currently in use across all cores.

**How it's calculated**:
- Uses `top` command to get CPU idle percentage
- Calculates CPU usage as: `100% - idle%`
- Represents real-time CPU consumption

**Threshold**: 60%

**Interpretation**:
- Below 60%: CPU is not a bottleneck; system has good headroom
- Above 60%: CPU is heavily utilized; investigate running processes

**When this increases**:
- Heavy computational workloads
- Application bugs causing infinite loops
- Insufficient CPU allocation for workload

### 2. Memory Utilization

**What it measures**: The percentage of RAM currently in use.

**How it's calculated**:
- Uses `free` command to determine total and used memory
- Calculates usage as: `(Used Memory / Total Memory) × 100`
- Includes all memory allocations (apps, buffers, cache)

**Threshold**: 60%

**Interpretation**:
- Below 60%: Sufficient memory available; system can handle spikes
- Above 60%: Memory pressure is high; risk of swap usage and performance degradation

**When this increases**:
- Running too many applications
- Memory leaks in applications
- Large data processing jobs
- Caching building up (databases, web servers)

### 3. Disk Space Utilization

**What it measures**: The percentage of root filesystem (/) capacity currently used.

**How it's calculated**:
- Uses `df` command to check root partition (/)
- Calculates percentage of used vs. total disk space
- Monitors only the primary filesystem

**Threshold**: 60%

**Interpretation**:
- Below 60%: Adequate disk space; room for system operations
- Above 60%: Limited disk space; risk of system malfunction, log truncation, temp file failures

**When this increases**:
- Application log files growing
- Old backups not cleaned up
- Large temporary files (downloads, compilations)
- Database files growing
- Core dumps from crashed applications

## Output Examples

### Scenario 1: Healthy System

```bash
$ ./vm_health_check.sh

Analyzing VM health...

===============================================
         VM HEALTH CHECK REPORT
===============================================
CPU Utilization:     25%
Memory Utilization:  40%
Disk Utilization:    35%
-----------------------------------------------
Status: HEALTHY
===============================================
```

**Exit Code**: 0

### Scenario 2: Not Healthy - High Disk Usage

```bash
$ ./vm_health_check.sh --explain

Analyzing VM health...

===============================================
         VM HEALTH CHECK REPORT
===============================================
CPU Utilization:     20%
Memory Utilization:  45%
Disk Utilization:    75%
-----------------------------------------------
Status: NOT HEALTHY
===============================================

===============================================
    VM HEALTH CHECK DETAILED REPORT
===============================================

CPU ANALYSIS:
  [GOOD] CPU usage is 20%
  Reason: CPU utilization is below threshold of 60%

MEMORY ANALYSIS:
  [GOOD] Memory usage is 45%
  Reason: Memory utilization is below threshold of 60%

DISK ANALYSIS:
  [CRITICAL] Disk usage is 75%
  Reason: Disk utilization exceeds threshold of 60%
  Recommendation: Free up disk space, consider:
    - Use 'du -sh /*' to identify large directories
    - Clean up old logs: 'sudo journalctl --vacuum=7d'
    - Remove unused packages: 'sudo apt-get autoremove'
    - Clean package cache: 'sudo apt-get clean'
    - Consider expanding disk capacity

-----------------------------------------------
Overall Status: NOT HEALTHY
===============================================
```

**Exit Code**: 1

## Automation & Integration

### Cron Job for Periodic Monitoring

Schedule the script to run every hour and log results:

```bash
# Add to crontab
crontab -e

# Add this line to run every hour
0 * * * * /home/user/vm_health_check.sh >> /var/log/vm_health.log 2>&1

# To run every 30 minutes
*/30 * * * * /home/user/vm_health_check.sh >> /var/log/vm_health.log 2>&1
```

### Integration with Monitoring Systems

#### Prometheus Monitoring

Create a simple exporter script:

```bash
#!/bin/bash
# prometheus_exporter.sh

output=$(/path/to/vm_health_check.sh 2>&1)
health_status=$(echo "$output" | grep "Status:" | awk '{print $(NF)}' | grep -o "[A-Z]*")

if [ "$health_status" = "HEALTHY" ]; then
    echo "vm_health_status 1"
else
    echo "vm_health_status 0"
fi
```

#### Nagios/Icinga Integration

```bash
#!/bin/bash
# nagios_check.sh

/path/to/vm_health_check.sh > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "OK - VM is HEALTHY"
    exit 0
else
    echo "CRITICAL - VM is NOT HEALTHY"
    /path/to/vm_health_check.sh --explain
    exit 2
fi
```

#### Alert on Unhealthy Status

```bash
#!/bin/bash
# alert_if_unhealthy.sh

/path/to/vm_health_check.sh > /dev/null 2>&1

if [ $? -ne 0 ]; then
    # Send alert email
    echo "$(/path/to/vm_health_check.sh --explain)" | \
    mail -s "VM Health Alert - $(hostname)" admin@example.com
fi
```

### Systemd Timer (Alternative to Cron)

```ini
# /etc/systemd/system/vm-health-check.service
[Unit]
Description=VM Health Check Service
After=network.target

[Service]
Type=oneshot
ExecStart=/path/to/vm_health_check.sh
StandardOutput=journal
StandardError=journal

# /etc/systemd/system/vm-health-check.timer
[Unit]
Description=VM Health Check Timer

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
```

Enable the timer:

```bash
sudo systemctl daemon-reload
sudo systemctl enable vm-health-check.timer
sudo systemctl start vm-health-check.timer
```

## Troubleshooting

### Script Permission Denied

**Problem**: `Permission denied: ./vm_health_check.sh`

**Solution**:
```bash
chmod +x vm_health_check.sh
./vm_health_check.sh
```

### Top Command Not Found

**Problem**: `top: command not found`

**Solution**:
```bash
# Install procps (includes top and free)
sudo apt-get update
sudo apt-get install procps
```

### Unable to Determine CPU Usage

**Problem**: CPU usage shows 0 or unexpected values

**Troubleshooting**:
- Ensure `top` is installed and working: `top -bn1 | head -5`
- Check system load: `uptime`
- Verify bash version: `bash --version` (needs 4.0+)

### High Disk Usage Diagnosis

**Find large directories**:
```bash
du -sh /* | sort -rh | head -10
```

**Find large files**:
```bash
find / -type f -size +100M 2>/dev/null | head -20
```

**Check journal logs**:
```bash
du -sh /var/log
journalctl --disk-usage
```

**Clean up old logs**:
```bash
sudo journalctl --vacuum=7d  # Keep only 7 days
sudo journalctl --vacuum=50M # Keep only 50MB
```

### High Memory Usage Diagnosis

**View detailed memory usage**:
```bash
free -h
```

**Find processes consuming most memory**:
```bash
ps aux --sort=-%mem | head -10
```

**Check for memory leaks**:
```bash
watch -n 1 'free -h && echo && ps aux --sort=-%mem | head -5'
```

### High CPU Usage Diagnosis

**View real-time CPU usage**:
```bash
top
htop  # More user-friendly alternative
```

**Find CPU-intensive processes**:
```bash
ps aux --sort=-%cpu | head -10
```

**Monitor CPU usage over time**:
```bash
watch -n 2 'ps aux --sort=-%cpu | head -10'
```

## Performance Considerations

### Script Execution Time
- Typical execution: < 1 second
- Minimal system overhead
- Safe to run frequently (every minute in cron jobs)

### Resource Usage
- CPU impact: Negligible (< 1% per execution)
- Memory impact: < 5MB
- Disk impact: No persistent storage

### Optimization Tips
- Run directly from local filesystem (not network mount)
- Avoid running many instances simultaneously
- Consider using cron for periodic checks instead of continuous polling

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Test thoroughly on Ubuntu systems
5. Commit your changes (`git commit -am 'Add improvement'`)
6. Push to the branch (`git push origin feature/improvement`)
7. Create a Pull Request

### Areas for Contribution
- Support for additional metrics (network, I/O)
- Output format options (JSON, CSV)
- Graphical dashboard integration
- Performance optimizations
- Additional OS support (Debian, CentOS, etc.)
- Localization support

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or suggestions:

- Open an [Issue](https://github.com/venkataprasaddamin1999-creator/MY-first-second/issues) on GitHub
- Check existing issues for solutions
- Include script output and system information when reporting bugs

## Changelog

### Version 1.0 (Initial Release)
- Initial release with CPU, Memory, and Disk monitoring
- Support for basic and explain modes
- Color-coded output
- Integration-ready exit codes
- Comprehensive documentation

---

**Last Updated**: 2026
**Maintainer**: System Administrator
**Repository**: [MY-first-second](https://github.com/venkataprasaddamin1999-creator/MY-first-second)