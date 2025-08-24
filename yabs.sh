#!/bin/bash
# VPS Information Script (style mirip YABS)

clear
echo "########################################"
echo "#                                      #"
echo "#           VPS INFORMATION            #"
echo "#                                      #"
echo "########################################"
echo

# Basic Info
UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
CPU_CORES=$(nproc)
CPU_MHZ=$(lscpu | awk '/MHz/ {print $3; exit}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2-)
KERNEL=$(uname -r)
VM_TYPE=$(systemd-detect-virt 2>/dev/null)

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

# Provider Info
ISP=$(curl -s ipinfo.io/org 2>/dev/null)
ASN=$(curl -s ipinfo.io/asn 2>/dev/null)
HOSTNAME=$(hostname)
LOCATION=$(curl -s ipinfo.io/region 2>/dev/null)
COUNTRY=$(curl -s ipinfo.io/country 2>/dev/null)

echo "Basic System Information:"
echo "-------------------------"
echo "Uptime        : $UPTIME"
echo "Processor     : $CPU_MODEL"
echo "CPU cores     : $CPU_CORES @ ${CPU_MHZ}MHz"
echo "RAM           : $RAM_USED / $RAM_TOTAL"
echo "Disk          : $DISK_USED / $DISK_TOTAL"
echo "Distro        : $DISTRO"
echo "Kernel        : $KERNEL"
echo "VM Type       : $VM_TYPE"
echo "IPv4/IPv6     : $IPV4 / $IPV6"
echo

echo "Network Information:"
echo "-------------------------"
echo "ISP           : $ISP"
echo "ASN           : $ASN"
echo "Host          : $HOSTNAME"
echo "Location      : $LOCATION"
echo "Country       : $COUNTRY"
echo
