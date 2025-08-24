#!/bin/bash
# Mini YABS Clone - VPS Benchmark Script

clear
echo "########################################"
echo "#                                      #"
echo "#           VPS INFORMATION            #"
echo "#                                      #"
echo "########################################"
echo

# =============================
# System Information
# =============================
UPTIME=$(uptime -p | sed 's/up //')
CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name:\s*//')
CPU_CORES=$(nproc)
CPU_SPEED=$(lscpu | awk '/MHz/ {printf "%.0f MHz\n", $3; exit}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
DISK_TOTAL=$(df -h --output=size / | tail -n1)
DISK_USED=$(df -h --output=used / | tail -n1)
DISTRO=$(lsb_release -d 2>/dev/null | cut -f2-)
KERNEL=$(uname -r)
VM_TYPE=$(systemd-detect-virt 2>/dev/null)

echo "Basic System Information:"
echo "-------------------------"
echo "Uptime        : $UPTIME"
echo "Processor     : $CPU_MODEL"
echo "CPU cores     : $CPU_CORES @ $CPU_SPEED"
echo "RAM           : $RAM_USED / $RAM_TOTAL"
echo "Disk (root)   : $DISK_USED / $DISK_TOTAL"
echo "Distro        : $DISTRO"
echo "Kernel        : $KERNEL"
echo "VM Type       : $VM_TYPE"
echo

# =============================
# Network Information
# =============================
IPV4=$(curl -4 -s ifconfig.co || echo "N/A")
IPV6=$(curl -6 -s ifconfig.co || echo "N/A")
ISP=$(curl -s ipinfo.io/org || echo "N/A")
ASN=$(curl -s ipinfo.io/asn || echo "N/A")
CITY=$(curl -s ipinfo.io/city || echo "N/A")
REGION=$(curl -s ipinfo.io/region || echo "N/A")
COUNTRY=$(curl -s ipinfo.io/country || echo "N/A")

echo "Network Information:"
echo "-------------------------"
echo "Public IPv4    : ${IPV4:-N/A}"
echo "Public IPv6    : ${IPV6:-N/A}"
echo "ISP            : $ISP"
echo "ASN            : $ASN"
echo "Location       : $CITY, $REGION ($COUNTRY)"
echo

# =============================
# Disk Speed Test
# =============================
echo "Disk Speed Test:"
echo "-------------------------"
dd if=/dev/zero of=testfile bs=1G count=1 oflag=dsync 2>&1 | grep copied
rm -f testfile
echo

# =============================
# Speedtest
# =============================
if command -v speedtest >/dev/null 2>&1; then
    echo "Network Speedtest:"
    echo "-------------------------"
    speedtest --simple
else
    echo "Speedtest CLI not installed. Installing..."
    apt-get update -y >/dev/null 2>&1 && apt-get install -y speedtest-cli >/dev/null 2>&1
    speedtest --simple
fi
