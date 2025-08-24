#!/bin/bash
# VPS Info Script (YABS style minimal)

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
CPU_FREQ=$(lscpu | awk -F: '/CPU MHz/ {printf "%.0f MHz\n", $2; exit}')
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
echo "Uptime        : $UPTIME"
echo "Processor     : $CPU_MODEL"
echo "CPU cores     : $CPU_CORES @ $CPU_FREQ"
echo "AES-NI        : $AES"
echo "VM-x/AMD-V    : $VMX"
echo "RAM           : $RAM_TOTAL"
echo "Disk          : $DISK_TOTAL"
echo "Distro        : $DISTRO"
echo "Kernel        : $KERNEL"
echo "VM Type       : $VM_TYPE"
echo "IPv4/IPv6     : $IPV4 / $IPV6"
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
echo "ASN      : $HOSTNAME"
echo "ISP           : $ISP"
echo "Hostname           : $ASN"
echo "Location      : $LOCATION"
echo "Country       : $COUNTRY"
