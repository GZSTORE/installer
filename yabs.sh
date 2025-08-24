#!/bin/bash
# VPS Info Script (YABS style minimal - fixed align)

clear
echo "########################################"
echo "#                                      #"
echo "#         VPS BASIC INFORMATION        #"
echo "#                                      #"
echo "########################################"
echo

# =============================
# Basic System Information
# =============================

UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
CPU_CORES=$(nproc)
CPU_FREQ=$(lscpu | awk -F: '/CPU max MHz/ {printf "%.0f MHz", $2}' | xargs)
if [ -z "$CPU_FREQ" ]; then
  CPU_FREQ=$(lscpu | awk -F: '/CPU MHz/ {printf "%.0f MHz", $2; exit}' | xargs)
fi
RAM_TOTAL=$(free -h --si | awk '/Mem:/ {print $2}')
DISK_TOTAL=$(df -h --output=size / | tail -n1)
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2-)
KERNEL=$(uname -r)
VM_TYPE=$(systemd-detect-virt 2>/dev/null)
AES=$(grep -m1 aes /proc/cpuinfo >/dev/null && echo "✓ Enabled" || echo "✗ Disabled")
VMX=$(grep -m1 vmx /proc/cpuinfo >/dev/null && echo "✓ Enabled" || echo "✗ Disabled")

# IPv4 / IPv6 check
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

# =============================
# Network Information
# =============================

ISP=$(curl -s ipinfo.io/org)
ASN=$(curl -s ipinfo.io/asn 2>/dev/null | head -n1)
HOSTNAME=$(hostname)
LOCATION=$(curl -s ipinfo.io/region)
COUNTRY=$(curl -s ipinfo.io/country)

echo "Network Information:"
echo "-------------------------"
printf "%-13s : %s\n" "Hostname" "$HOSTNAME"
printf "%-13s : %s\n" "ISP" "$ISP"
printf "%-13s : %s\n" "ASN" "$ASN"
printf "%-13s : %s\n" "Location" "$LOCATION"
printf "%-13s : %s\n" "Country" "$COUNTRY"
