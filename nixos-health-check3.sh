#!/usr/bin/env bash
# =============================================================================
# NIXOS SYSTEM HEALTH CHECK SCRIPT
# =============================================================================
# Comprehensive system check for NixOS desktops with NVIDIA, KDE Plasma, and virtualization
# =============================================================================

set -euo pipefail

# -------------------------
# Color codes for output
# -------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================ NixOS System Health Check ================${NC}"

# -------------------------
# Hostname and uptime
# -------------------------
echo -e "${GREEN}Hostname:${NC} $(hostname)"
echo -e "${GREEN}Uptime:${NC} $(uptime -p)"

# -------------------------
# CPU info
# -------------------------
echo -e "\n${YELLOW}CPU Information:${NC}"
lscpu | grep -E 'Model name|CPU\(s\)|Architecture|CPU MHz'

# -------------------------
# Memory usage
# -------------------------
echo -e "\n${YELLOW}Memory Usage:${NC}"
free -h

# -------------------------
# Disk usage
# -------------------------
echo -e "\n${YELLOW}Disk Usage:${NC}"
df -h | grep -v tmpfs

# -------------------------
# Filesystem health
# -------------------------
echo -e "\n${YELLOW}Filesystem Health:${NC}"
lsblk -f

# -------------------------
# NVIDIA GPU check
# -------------------------
if command -v nvidia-smi &>/dev/null; then
    echo -e "\n${YELLOW}NVIDIA GPU Status:${NC}"
    nvidia-smi
else
    echo -e "\n${RED}NVIDIA GPU not detected or drivers not installed.${NC}"
fi

# -------------------------
# PRIME offload test
# -------------------------
if command -v glxinfo &>/dev/null; then
    echo -e "\n${YELLOW}PRIME Render Offload Test:${NC}"
    __NV_PRIME_RENDER_OFFLOAD=1 glxinfo | grep "OpenGL renderer"
fi

# -------------------------
# Kernel modules
# -------------------------
echo -e "\n${YELLOW}Loaded Kernel Modules:${NC}"
lsmod | grep -E 'nvidia|nouveau|i915|snd|bluetooth' || echo "Modules not detected"

# -------------------------
# Journal Errors/Warnings
# -------------------------
echo -e "\n${YELLOW}Recent Journal Errors (last 1 hour):${NC}"
journalctl -p 3 --since "1 hour ago" --no-pager || echo "No recent errors"

echo -e "\n${YELLOW}Recent Journal Warnings (last 1 hour):${NC}"
journalctl -p 4 --since "1 hour ago" --no-pager || echo "No recent warnings"

# -------------------------
# Systemd services status
# -------------------------
echo -e "\n${YELLOW}Critical Systemd Services Status:${NC}"
for service in sddm NetworkManager pipewire wireplumber sshd libvirtd docker; do
    echo -e "\nService: ${service}"
    systemctl is-active "${service}" && echo -e "${GREEN}Active${NC}" || echo -e "${RED}Inactive${NC}"
done

# -------------------------
# PipeWire / Audio check
# -------------------------
echo -e "\n${YELLOW}PipeWire / Audio Status:${NC}"
if systemctl --user is-active pipewire &>/dev/null; then
    pactl info | grep "Server Name"
else
    echo -e "${RED}PipeWire not running${NC}"
fi

# -------------------------
# Network status
# -------------------------
echo -e "\n${YELLOW}Network Interfaces:${NC}"
nmcli device status

echo -e "\n${YELLOW}Firewall Status:${NC}"
sudo firewall-cmd --state 2>/dev/null || echo "Firewall not managed by firewalld"

# -------------------------
# Virtualization check
# -------------------------
echo -e "\n${YELLOW}Virtualization Info:${NC}"
if command -v virsh &>/dev/null; then
    virsh list --all
else
    echo "Libvirt not installed or not running"
fi

# -------------------------
# Bluetooth status
# -------------------------
echo -e "\n${YELLOW}Bluetooth Status:${NC}"
rfkill list bluetooth
systemctl is-active bluetooth && echo -e "${GREEN}Bluetooth service running${NC}" || echo -e "${RED}Bluetooth inactive${NC}"

# -------------------------
# Power / Battery status
# -------------------------
if command -v upower &>/dev/null; then
    echo -e "\n${YELLOW}Battery Status:${NC}"
    upower -i $(upower -e | grep BAT) || echo "Battery info unavailable"
fi

# -------------------------
# Optional: Thermal info
# -------------------------
if [ -d /sys/class/thermal ]; then
    echo -e "\n${YELLOW}Thermal Zones:${NC}"
    for t in /sys/class/thermal/thermal_zone*; do
        echo -n "$(basename "$t"): "
        cat "$t/temp" 2>/dev/null || echo "N/A"
    done
fi

echo -e "\n${BLUE}================ End of Health Check ================${NC}"
