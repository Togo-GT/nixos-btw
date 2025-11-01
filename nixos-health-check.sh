#!/bin/bash

# =============================================================================
# NIXOS SYSTEM HEALTH CHECK SCRIPT
# =============================================================================
# Comprehensive system status check for NixOS with NVIDIA, KDE Plasma, and Qt6
# =============================================================================

echo "================================================================"
echo "                   NIXOS SYSTEM HEALTH CHECK"
echo "================================================================"
echo "System: $(nixos-version)"
echo "Kernel: $(uname -r)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo "================================================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check service status
check_service() {
    local service_name=$1
    local display_name=$2
    local status=$(systemctl is-active "$service_name")

    if [ "$status" = "active" ]; then
        echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
    elif [ "$status" = "inactive" ]; then
        echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
    else
        echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
    fi
}

# Function to check user service status
check_user_service() {
    local service_name=$1
    local display_name=$2
    local status=$(systemctl --user is-active "$service_name")

    if [ "$status" = "active" ]; then
        echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
    elif [ "$status" = "inactive" ]; then
        echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
    else
        echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo
echo -e "${BLUE}=== DISPLAY & GRAPHICS ===${NC}"

# Check display manager
check_service "sddm" "SDDM Display Manager"

# Check if X11 is running
if pgrep -x "Xorg" > /dev/null; then
    echo -e "${GREEN}✓${NC} X11 Server: ${GREEN}Running${NC}"
else
    echo -e "${RED}✗${NC} X11 Server: ${RED}Not running${NC}"
fi

# Check desktop environment
if pgrep -x "plasmashell" > /dev/null; then
    echo -e "${GREEN}✓${NC} KDE Plasma: ${GREEN}Running${NC}"
else
    echo -e "${YELLOW}?${NC} KDE Plasma: ${YELLOW}Not detected (may not be started)${NC}"
fi

echo
echo -e "${BLUE}=== NVIDIA GRAPHICS ===${NC}"

# Check NVIDIA kernel modules
nvidia_modules=$(lsmod | grep nvidia | wc -l)
if [ $nvidia_modules -ge 4 ]; then
    echo -e "${GREEN}✓${NC} NVIDIA Modules: ${GREEN}$nvidia_modules loaded${NC}"
else
    echo -e "${RED}✗${NC} NVIDIA Modules: ${RED}Only $nvidia_modules loaded${NC}"
fi

# Check nvidia-smi
if command_exists nvidia-smi; then
    nvidia_driver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1)
    gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -1)
    echo -e "${GREEN}✓${NC} NVIDIA Driver: ${GREEN}$nvidia_driver${NC}"
    echo -e "${GREEN}✓${NC} GPU: ${GREEN}$gpu_name${NC}"

    # Check GPU utilization
    gpu_util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | head -1 | tr -d ' %')
    if [ "$gpu_util" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} GPU Utilization: ${GREEN}Idle${NC}"
    else
        echo -e "${GREEN}✓${NC} GPU Utilization: ${GREEN}${gpu_util}%${NC}"
    fi
else
    echo -e "${RED}✗${NC} NVIDIA SMI: ${RED}Not available${NC}"
fi

# Check PRIME
if command_exists prime-run; then
    echo -e "${GREEN}✓${NC} NVIDIA PRIME: ${GREEN}Available${NC}"
else
    echo -e "${YELLOW}?${NC} NVIDIA PRIME: ${YELLOW}Not detected${NC}"
fi

echo
echo -e "${BLUE}=== AUDIO ===${NC}"

# Check PipeWire services
check_user_service "pipewire" "PipeWire Audio"
check_user_service "pipewire-pulse" "PipeWire PulseAudio"

# Check audio devices
if command_exists pactl; then
    audio_sinks=$(pactl list sinks short | wc -l)
    if [ $audio_sinks -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Audio Devices: ${GREEN}$audio_sinks sink(s) detected${NC}"
    else
        echo -e "${RED}✗${NC} Audio Devices: ${RED}No sinks detected${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} PulseAudio: ${YELLOW}pactl not available${NC}"
fi

echo
echo -e "${BLUE}=== NETWORKING ===${NC}"

# Check NetworkManager
check_service "NetworkManager" "NetworkManager"

# Check network connectivity
if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Internet: ${GREEN}Connected${NC}"
else
    echo -e "${RED}✗${NC} Internet: ${RED}No connection${NC}"
fi

# Check WiFi/BT
check_service "bluetooth" "Bluetooth Service"

echo
echo -e "${BLUE}=== SYSTEM SERVICES ===${NC}"

check_service "docker" "Docker Service"
check_service "libvirtd" "Libvirt Virtualization"
check_service "cups" "Printing Service"
check_service "tlp" "Power Management"
check_service "fstrim.timer" "SSD Trim Timer"
check_service "avahi-daemon" "Network Discovery"
check_service "fwupd" "Firmware Updates"
check_service "thermald" "Thermal Management"
check_service "ssh" "SSH Service"

echo
echo -e "${BLUE}=== SYSTEM INFORMATION ===${NC}"

# Check disk space
echo -e "${BLUE}Disk Usage:${NC}"
df -h / | awk 'NR==2 {printf "✓ Root: %s/%s (%s used)\n", $4, $2, $5}'

# Check memory
echo -e "${BLUE}Memory Usage:${NC}"
free -h | awk 'NR==2 {printf "✓ RAM: %s/%s used\n", $3, $2}'

# Check CPU
cpu_cores=$(nproc)
cpu_load=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | tr -d ' ')
echo -e "${BLUE}CPU:${NC} $cpu_cores cores, Load: $cpu_load"

# Check temperature if sensors command exists
if command_exists sensors; then
    cpu_temp=$(sensors | grep -E "Package id|Core" | head -1 | awk '{print $4}')
    echo -e "${BLUE}Temperature:${NC} $cpu_temp"
fi

echo
echo -e "${BLUE}=== DEVELOPMENT & CONTAINERS ===${NC}"

# Check development tools
if command_exists docker; then
    echo -e "${GREEN}✓${NC} Docker: ${GREEN}$(docker --version | cut -d' ' -f3)${NC}"
else
    echo -e "${RED}✗${NC} Docker: ${RED}Not available${NC}"
fi

if command_exists podman; then
    echo -e "${GREEN}✓${NC} Podman: ${GREEN}$(podman --version | cut -d' ' -f3)${NC}"
else
    echo -e "${YELLOW}?${NC} Podman: ${YELLOW}Not available${NC}"
fi

# Check programming languages
if command_exists python3; then
    echo -e "${GREEN}✓${NC} Python: ${GREEN}$(python3 --version | cut -d' ' -f2)${NC}"
fi

if command_exists node; then
    echo -e "${GREEN}✓${NC} Node.js: ${GREEN}$(node --version)${NC}"
fi

if command_exists go; then
    echo -e "${GREEN}✓${NC} Go: ${GREEN}$(go version | cut -d' ' -f3)${NC}"
fi

echo
echo -e "${BLUE}=== USER ENVIRONMENT ===${NC}"

# Check shell
echo -e "${BLUE}Shell:${NC} $SHELL ($(zsh --version 2>/dev/null | head -1 || echo "Unknown version"))"

# Check environment variables
echo -e "${BLUE}QT Platform:${NC} ${QT_QPA_PLATFORM:-Not set}"
echo -e "${BLUE}Desktop:${NC} ${XDG_CURRENT_DESKTOP:-Not set}"

# Check user groups
if groups | grep -q wheel; then
    echo -e "${GREEN}✓${NC} User Groups: ${GREEN}Wheel group access OK${NC}"
else
    echo -e "${RED}✗${NC} User Groups: ${RED}No wheel group access${NC}"
fi

echo
echo -e "${BLUE}=== GRAPHICS & PERFORMANCE ===${NC}"

# Check OpenGL
if command_exists glxinfo; then
    opengl_vendor=$(glxinfo | grep "OpenGL vendor" | head -1 | cut -d: -f2 | xargs)
    opengl_version=$(glxinfo | grep "OpenGL version" | head -1 | cut -d: -f2 | xargs)
    echo -e "${GREEN}✓${NC} OpenGL Vendor: $opengl_vendor"
    echo -e "${GREEN}✓${NC} OpenGL Version: $opengl_version"
fi

# Check Vulkan
if command_exists vulkaninfo; then
    vulkan_version=$(vulkaninfo --summary 2>/dev/null | grep "Vulkan API" | head -1 | cut -d: -f2 | xargs)
    if [ ! -z "$vulkan_version" ]; then
        echo -e "${GREEN}✓${NC} Vulkan: $vulkan_version"
    else
        echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}Available but no version info${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}vulkaninfo not available${NC}"
fi

echo
echo -e "${BLUE}=== APPLICATION CHECK ===${NC}"

# Check key applications
apps=("firefox" "dolphin" "kate" "konsole" "chromium" "okular" "gimp" "vlc")
for app in "${apps[@]}"; do
    if command_exists "$app"; then
        echo -e "${GREEN}✓${NC} $app: ${GREEN}Available${NC}"
    else
        echo -e "${YELLOW}?${NC} $app: ${YELLOW}Not available${NC}"
    fi
done

echo
echo -e "${BLUE}=== ERROR CHECK ===${NC}"

# Check for recent errors in journal
error_count=$(journalctl --since "1 hour ago" -p 3 | grep -c "ERROR\|FAILED")
if [ $error_count -eq 0 ]; then
    echo -e "${GREEN}✓${NC} System Logs: ${GREEN}No recent errors found${NC}"
else
    echo -e "${YELLOW}!${NC} System Logs: ${YELLOW}$error_count recent errors - check with 'journalctl -p 3 -xb'${NC}"
fi

# Check X11 errors
if [ -f "/var/log/Xorg.0.log" ]; then
    xerrors=$(grep -c "(EE)" /var/log/Xorg.0.log)
    if [ $xerrors -eq 0 ]; then
        echo -e "${GREEN}✓${NC} X11 Logs: ${GREEN}No errors found${NC}"
    else
        echo -e "${YELLOW}!${NC} X11 Logs: ${YELLOW}$xerrors errors found${NC}"
    fi
fi

echo
echo "================================================================"
echo -e "${GREEN}HEALTH CHECK COMPLETE${NC}"
echo "================================================================"
echo "For detailed logs:"
echo "  System errors: journalctl -p 3 -xb"
echo "  X11 logs: cat /var/log/Xorg.0.log | grep -i error"
echo "  Service status: systemctl status <service-name>"
echo "================================================================"
