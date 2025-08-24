#!/bin/bash
# VPS Information Script (Clean & Fixed Version)

clear
echo "########################################"
echo "#                                      #"
echo "#           VPS INFORMATION            #"
echo "#                                      #"
echo "########################################"
echo

# Basic Info
UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//;s/^[ \t]*//')
CPU_CORES=$(nproc)

# CPU Frequency (universal check)
CPU_FREQ=$(lscpu | awk -F: '/MHz/ {gsub(/^[ \t]+/, "", $2); print $2; exit}')
if [ -z "$CPU_FREQ" ]; then
  CPU_FREQ=$(grep -m1 "cpu MHz" /proc/cpuinfo | awk '{print $4}')
fi
if [ -z "$CPU_FREQ" ]; then
  CPU_FREQ="Unknown"
else
  CPU_FREQ="${CPU_FREQ} MHz"
fi

# AES-NI & Virt check
AES=$(grep -q aes /proc/cpuinfo && echo "✓ Enabled" || echo "✗ Disabled")
VMX=$(grep -Eq 'vmx|svm' /proc/cpuinfo && echo "✓ Enabled" || echo "✗ Disabled")

# RAM & Disk
RAM_TOTAL=$(free -h --si | awk '/Mem:/ {print $2}')
DISK_TOTAL=$(df -h --total | awk '/total/ {print $2}')

# OS Info
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2- || echo "Unknown")
KERNEL=$(uname -r)
VM_TYPE=$(systemd-detect-virt 2>/dev/null || echo "Unknown")

# IPv4 / IPv6 status
if curl -4 -s --max-time 3 ifconfig.co > /dev/null; then
  IPV4="✓ Online"
else
  IPV4="✗ Offline"
fi
if curl -6 -s --max-time 3 ifconfig.co > /dev/null; then
  IPV6="✓ Online"
else
  IPV6="✗ Offline"
fi

# Network Info
HOSTNAME=$(hostname)
ISP=$(curl -s ipinfo.io/org || echo "Unknown")
ASN=$(curl -s ipinfo.io/asn || echo "Unknown")
LOCATION=$(curl -s ipinfo.io/region || echo "Unknown")
COUNTRY=$(curl -s ipinfo.io/country || echo "Unknown")

# Output
echo "Basic System Information:"
echo "-------------------------"
printf "%-13s : %s\n" "Uptime" "$UPTIME"
printf "%-13s : %s\n" "Processor" "$CPU_MODEL"
printf "%-13s : %s\n" "CPU cores" "$CPU_CORES @ $CPU_FREQ"
printf "%-13s : %s\n" "AES-NI" "$AES"
printf "%-13s : %s\n" "VM-x/AMD-V" "$VMX"
printf "%-13s : %s\n" "RAM" "$RAM_TOTAL"
printf "%-13s : %s\n" "Disk" "$DISK_TOTAL"
printf "%-13s : %s\n" "Distro" "$DISTRO"
printf "%-13s : %s\n" "Kernel" "$KERNEL"
printf "%-13s : %s\n" "VM Type" "$VM_TYPE"
printf "%-13s : %s / %s\n" "IPv4/IPv6" "$IPV4" "$IPV6"
echo
echo "Network Information:"
echo "-------------------------"
printf "%-13s : %s\n" "Hostname" "$HOSTNAME"
printf "%-13s : %s\n" "ISP" "$ISP"
printf "%-13s : %s\n" "ASN" "$ASN"
printf "%-13s : %s\n" "Location" "$LOCATION"
printf "%-13s : %s\n" "Country" "$COUNTRY"
