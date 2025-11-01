#!/bin/bash

# =============================================================================
# NIXOS SYSTEM HEALTH CHECK SCRIPT
# =============================================================================
# Comprehensive system status check for NixOS with NVIDIA, KDE Plasma, and Qt6
# Enhanced version with NixOS-specific checks and better error handling
# =============================================================================

set -eu  # Exit on error and undefined variables

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Header function
print_header() {
    echo
    echo -e "${PURPLE}=== $1 ===${NC}"
}

# Function to check service status
check_service() {
    local service_name=$1
    local display_name=$2
    local status=$(systemctl is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        "active")
            echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
            ;;
        "inactive")
            echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
            ;;
        "failed")
            echo -e "${RED}✗${NC} $display_name: ${RED}Failed${NC}"
            ;;
        "not-found")
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}Not installed${NC}"
            ;;
        *)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
            ;;
    esac
}

# Function to check user service status
check_user_service() {
    local service_name=$1
    local display_name=$2
    local status=$(systemctl --user is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        "active")
            echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
            ;;
        "inactive")
            echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
            ;;
        "failed")
            echo -e "${RED}✗${NC} $display_name: ${RED}Failed${NC}"
            ;;
        "not-found")
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}Not installed${NC}"
            ;;
        *)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
            ;;
    esac
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check NVIDIA hybrid graphics
check_nvidia_hybrid() {
    if lspci 2>/dev/null | grep -q "NVIDIA"; then
        echo -e "${GREEN}✓${NC} NVIDIA GPU: ${GREEN}Hardware detected${NC}"

        # Check if using NVIDIA prime offload
        if [ -f "/run/opengl-driver/lib/libGLX_nvidia.so.0" ] || [ -f "/run/opengl-driver-32/lib/libGLX_nvidia.so.0" ]; then
            echo -e "${GREEN}✓${NC} NVIDIA OpenGL: ${GREEN}Available for offloading${NC}"
        fi

        # Check prime-offload service
        if systemctl --user is-active nvidia-powerd >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} NVIDIA Power Management: ${GREEN}Active${NC}"
        fi
    else
        echo -e "${YELLOW}?${NC} NVIDIA GPU: ${YELLOW}No NVIDIA hardware detected${NC}"
    fi
}

# Function to check journal errors
check_journal_errors() {
    local errors=0
    local warnings=0

    # Count errors with better error handling
    if journalctl --since "1 hour ago" -p 3 &>/dev/null; then
        errors=$(journalctl --since "1 hour ago" -p 3 2>/dev/null | grep -c "ERROR\|FAILED" 2>/dev/null || echo "0")
    fi

    if journalctl --since "1 hour ago" -p 4 &>/dev/null; then
        warnings=$(journalctl --since "1 hour ago" -p 4 2>/dev/null | grep -c "WARNING" 2>/dev/null || echo "0")
    fi

    # Convert to integers and handle empty values
    errors=$((errors + 0))
    warnings=$((warnings + 0))

    if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} System Logs: ${GREEN}No recent errors or warnings${NC}"
    elif [ "$errors" -eq 0 ]; then
        echo -e "${YELLOW}!${NC} System Logs: ${YELLOW}$warnings warnings - no errors${NC}"
    else
        echo -e "${RED}!${NC} System Logs: ${RED}$errors errors, $warnings warnings in last hour${NC}"
    fi

    # Return values for exit code
    JOURNAL_ERRORS=$errors
    JOURNAL_WARNINGS=$warnings
}

# Check if running on NixOS
if [ ! -f "/etc/NIXOS" ]; then
    echo -e "${RED}Error: This script is designed for NixOS systems only.${NC}"
    exit 1
fi

# Check if running as root for some checks
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}Warning: Running as root, some user services may not be detectable.${NC}"
fi

# Handle logging option
LOG_FILE=""
if [ "${1:-}" = "--log" ] && [ -n "${2:-}" ]; then
    LOG_FILE="$2"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi

# Display header
echo "================================================================"
echo "                   NIXOS SYSTEM HEALTH CHECK"
echo "================================================================"
echo "System: $(nixos-version 2>/dev/null || echo "Unknown")"
echo "Kernel: $(uname -r)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p | sed 's/up //')"
echo "================================================================"

# =============================================================================
# NIXOS SPECIFIC CHECKS
# =============================================================================
print_header "NIXOS SPECIFIC"

# Check current generation
if command_exists nixos-rebuild; then
    current_gen=$(nixos-rebuild list-generations 2>/dev/null | grep "current" | head -1 | awk '{print $1, $2, $3, $4, $5}')
    if [ -n "$current_gen" ]; then
        echo -e "${GREEN}✓${NC} Current Generation: ${GREEN}$current_gen${NC}"
    else
        current_gen=$(nixos-rebuild list-generations 2>/dev/null | tail -1 | awk '{print $1, $2, $3, $4, $5}')
        echo -e "${BLUE}ℹ${NC} Current Generation: ${BLUE}$current_gen${NC}"
    fi
fi

# Check if system is built from flake
if [ -f "/etc/NIXOS" ] && [ -f "/etc/os-release" ]; then
    if [ -f "/etc/nixos/flake.nix" ] || [ -d "/etc/nixos/flake.nix" ]; then
        echo -e "${GREEN}✓${NC} System: ${GREEN}Flake-based configuration${NC}"
    else
        echo -e "${BLUE}ℹ${NC} System: ${BLUE}Traditional configuration${NC}"
    fi
fi

# Check nix channels
if command_exists nix-channel; then
    channel_list=$(nix-channel --list 2>/dev/null)
    if [ -n "$channel_list" ]; then
        echo -e "${GREEN}✓${NC} Nix Channels: ${GREEN}Configured${NC}"
        echo -e "${CYAN}Channels:${NC}"
        echo "$channel_list" | while read -r channel; do
            echo -e "  ${CYAN}-${NC} $channel"
        done
    else
        echo -e "${YELLOW}?${NC} Nix Channels: ${YELLOW}None configured${NC}"
    fi
fi

# Check nix package manager version
if command_exists nix; then
    nix_version=$(nix --version | head -1)
    echo -e "${GREEN}✓${NC} $nix_version"
fi

# =============================================================================
# DISPLAY & GRAPHICS
# =============================================================================
print_header "DISPLAY & GRAPHICS"

# Check display manager
check_service "display-manager" "Display Manager"
check_service "sddm" "SDDM Display Manager"

# Check if X11/Wayland is running
if pgrep -x "Xorg" > /dev/null; then
    echo -e "${GREEN}✓${NC} X11 Server: ${GREEN}Running${NC}"
    # Get X11 display info
    if [ -n "$DISPLAY" ]; then
        echo -e "${BLUE}ℹ${NC} X11 Display: ${BLUE}$DISPLAY${NC}"
    fi
elif pgrep -x "wayland" > /dev/null || pgrep -f "wayland" > /dev/null; then
    echo -e "${GREEN}✓${NC} Wayland: ${GREEN}Running${NC}"
else
    echo -e "${RED}✗${NC} Display Server: ${RED}Not running${NC}"
fi

# Check desktop environment
if pgrep -x "plasmashell" > /dev/null; then
    echo -e "${GREEN}✓${NC} KDE Plasma: ${GREEN}Running${NC}"
    # Check KDE Plasma version
    if command_exists kf5-config; then
        kde_version=$(kf5-config --version | grep "KDE Frameworks" | awk '{print $2}')
        echo -e "${BLUE}ℹ${NC} KDE Frameworks: ${BLUE}$kde_version${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} KDE Plasma: ${YELLOW}Not detected (may not be started)${NC}"
fi

# =============================================================================
# NVIDIA GRAPHICS
# =============================================================================
print_header "NVIDIA GRAPHICS"

check_nvidia_hybrid

# Check NVIDIA kernel modules
nvidia_modules=$(lsmod | grep -c nvidia || true)
if [ "$nvidia_modules" -ge 4 ]; then
    echo -e "${GREEN}✓${NC} NVIDIA Modules: ${GREEN}$nvidia_modules loaded${NC}"
elif [ "$nvidia_modules" -gt 0 ]; then
    echo -e "${YELLOW}?${NC} NVIDIA Modules: ${YELLOW}$nvidia_modules loaded (partial)${NC}"
else
    echo -e "${RED}✗${NC} NVIDIA Modules: ${RED}None loaded${NC}"
fi

# Check nvidia-smi
if command_exists nvidia-smi; then
    nvidia_driver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1 || echo "Unknown")
    gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1 || echo "Unknown")
    gpu_count=$(nvidia-smi --query-gpu=count --format=csv,noheader 2>/dev/null | head -1 || echo "0")

    echo -e "${GREEN}✓${NC} NVIDIA Driver: ${GREEN}$nvidia_driver${NC}"
    echo -e "${GREEN}✓${NC} GPU: ${GREEN}$gpu_name${NC}"
    echo -e "${BLUE}ℹ${NC} GPU Count: ${BLUE}$gpu_count${NC}"

    # Check GPU utilization
    gpu_util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null | head -1 | tr -d ' %' || echo "0")
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null | head -1 || echo "N/A")

    if [ "$gpu_util" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} GPU Utilization: ${GREEN}Idle${NC}"
    else
        echo -e "${GREEN}✓${NC} GPU Utilization: ${GREEN}${gpu_util}%${NC}"
    fi
    echo -e "${BLUE}ℹ${NC} GPU Temperature: ${BLUE}${gpu_temp}°C${NC}"
else
    echo -e "${RED}✗${NC} NVIDIA SMI: ${RED}Not available${NC}"
fi

# Check PRIME
if command_exists prime-run; then
    echo -e "${GREEN}✓${NC} NVIDIA PRIME: ${GREEN}Available${NC}"
else
    echo -e "${YELLOW}?${NC} NVIDIA PRIME: ${YELLOW}Not detected${NC}"
fi

# =============================================================================
# AUDIO
# =============================================================================
print_header "AUDIO"

# Check PipeWire services
check_user_service "pipewire" "PipeWire Audio"
check_user_service "pipewire-pulse" "PipeWire PulseAudio"
check_user_service "wireplumber" "WirePlumber Session Manager"

# Check audio devices
if command_exists pactl; then
    audio_sinks=$(pactl list sinks short 2>/dev/null | wc -l)
    audio_sources=$(pactl list sources short 2>/dev/null | wc -l)

    if [ "$audio_sinks" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Audio Sinks: ${GREEN}$audio_sinks detected${NC}"
    else
        echo -e "${RED}✗${NC} Audio Sinks: ${RED}None detected${NC}"
    fi

    if [ "$audio_sources" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Audio Sources: ${GREEN}$audio_sources detected${NC}"
    else
        echo -e "${RED}✗${NC} Audio Sources: ${RED}None detected${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} PulseAudio: ${YELLOW}pactl not available${NC}"
fi

# =============================================================================
# NETWORKING
# =============================================================================
print_header "NETWORKING"

# Check NetworkManager
check_service "NetworkManager" "NetworkManager"

# Check network connectivity
if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Internet: ${GREEN}Connected${NC}"

    # Get public IP (optional)
    if command_exists curl; then
        public_ip=$(curl -s https://ipinfo.io/ip || echo "Unknown")
        echo -e "${BLUE}ℹ${NC} Public IP: ${BLUE}$public_ip${NC}"
    fi
else
    echo -e "${RED}✗${NC} Internet: ${RED}No connection${NC}"
fi

# Check network interfaces
echo -e "${CYAN}Network Interfaces:${NC}"
ip -o addr show | awk '{print $2, $4}' | while read -r interface ip; do
    if [ "$interface" != "lo" ]; then
        echo -e "  ${CYAN}-${NC} $interface: $ip"
    fi
done

# Check WiFi/BT
check_service "bluetooth" "Bluetooth Service"
if command_exists rfkill; then
    rfkill_list=$(rfkill list)
    echo -e "${CYAN}RFKill Status:${NC}"
    echo "$rfkill_list" | while read -r line; do
        echo -e "  ${CYAN}-${NC} $line"
    done
fi

# =============================================================================
# SYSTEM SERVICES
# =============================================================================
print_header "SYSTEM SERVICES"

check_service "docker" "Docker Service"
check_service "libvirtd" "Libvirt Virtualization"
check_service "cups" "Printing Service"
check_service "tlp" "Power Management"
check_service "fstrim.timer" "SSD Trim Timer"
check_service "avahi-daemon" "Network Discovery"
check_service "fwupd" "Firmware Updates"
check_service "thermald" "Thermal Management"
check_service "ssh" "SSH Service"
check_service "dbus" "D-Bus System Bus"

# =============================================================================
# SYSTEM INFORMATION
# =============================================================================
print_header "SYSTEM INFORMATION"

# Check disk space
echo -e "${CYAN}Disk Usage:${NC}"
df -h / | awk 'NR==2 {printf "  ✓ Root: %s/%s (%s used)\n", $4, $2, $5}'
df -h /home 2>/dev/null | awk 'NR==2 {printf "  ✓ Home: %s/%s (%s used)\n", $4, $2, $5}' || true
df -h /nix 2>/dev/null | awk 'NR==2 {printf "  ✓ Nix: %s/%s (%s used)\n", $4, $2, $5}' || true

# Check memory
echo -e "${CYAN}Memory Usage:${NC}"
free -h | awk 'NR==2 {printf "  ✓ RAM: %s/%s used (%.0f%%)\n", $3, $2, $3/$2 * 100}'
free -h | awk 'NR==3 {printf "  ✓ Swap: %s/%s used\n", $3, $2}'

# Check CPU
cpu_cores=$(nproc)
cpu_load=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | tr -d ' ')
cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
echo -e "${CYAN}CPU:${NC}"
echo -e "  ${CYAN}-${NC} Model: $cpu_model"
echo -e "  ${CYAN}-${NC} Cores: $cpu_cores"
echo -e "  ${CYAN}-${NC} Load: $cpu_load"

# Check temperature if sensors command exists
if command_exists sensors; then
    echo -e "${CYAN}Temperatures:${NC}"
    sensors | grep -E "Package id|Core|temp1" | head -3 | while read -r line; do
        echo -e "  ${CYAN}-${NC} $line"
    done
fi

# =============================================================================
# PACKAGE MANAGEMENT & DEVELOPMENT
# =============================================================================
print_header "PACKAGE MANAGEMENT & DEVELOPMENT"

# Check Flatpak
if command_exists flatpak; then
    flatpak_count=$(flatpak list --app 2>/dev/null | wc -l || echo "0")
    echo -e "${GREEN}✓${NC} Flatpak: ${GREEN}$flatpak_count applications${NC}"
else
    echo -e "${YELLOW}?${NC} Flatpak: ${YELLOW}Not available${NC}"
fi

# Check common NixOS tools
nix_tools=("nix-shell" "home-manager" "nixops" "nix-index" "nix-search")
for tool in "${nix_tools[@]}"; do
    if command_exists "$tool"; then
        echo -e "${GREEN}✓${NC} $tool: ${GREEN}Available${NC}"
    else
        echo -e "${BLUE}ℹ${NC} $tool: ${BLUE}Not installed${NC}"
    fi
done

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

if command_exists rustc; then
    echo -e "${GREEN}✓${NC} Rust: ${GREEN}$(rustc --version | cut -d' ' -f2)${NC}"
fi

# =============================================================================
# USER ENVIRONMENT
# =============================================================================
print_header "USER ENVIRONMENT"

# Check shell
current_shell=$(basename "$SHELL")
echo -e "${CYAN}Shell:${NC} $current_shell"

case $current_shell in
    "zsh")
        echo -e "  ${CYAN}-${NC} Version: $(zsh --version 2>/dev/null | head -1 || echo "Unknown")"
        ;;
    "bash")
        echo -e "  ${CYAN}-${NC} Version: $(bash --version 2>/dev/null | head -1 || echo "Unknown")"
        ;;
    "fish")
        echo -e "  ${CYAN}-${NC} Version: $(fish --version 2>/dev/null | head -1 || echo "Unknown")"
        ;;
esac

# Check environment variables
echo -e "${CYAN}Environment:${NC}"
echo -e "  ${CYAN}-${NC} QT Platform: ${QT_QPA_PLATFORM:-Not set}"
echo -e "  ${CYAN}-${NC} Desktop: ${XDG_CURRENT_DESKTOP:-Not set}"
echo -e "  ${CYAN}-${NC} Session: ${XDG_SESSION_TYPE:-Not set}"

# Check user groups
if groups | grep -q wheel; then
    echo -e "${GREEN}✓${NC} User Groups: ${GREEN}Wheel group access OK${NC}"
else
    echo -e "${RED}✗${NC} User Groups: ${RED}No wheel group access${NC}"
fi

# =============================================================================
# GRAPHICS & PERFORMANCE
# =============================================================================
print_header "GRAPHICS & PERFORMANCE"

# Check OpenGL
if command_exists glxinfo; then
    opengl_vendor=$(glxinfo 2>/dev/null | grep "OpenGL vendor" | head -1 | cut -d: -f2 | xargs || echo "Unknown")
    opengl_version=$(glxinfo 2>/dev/null | grep "OpenGL version" | head -1 | cut -d: -f2 | xargs || echo "Unknown")
    opengl_renderer=$(glxinfo 2>/dev/null | grep "OpenGL renderer" | head -1 | cut -d: -f2 | xargs || echo "Unknown")

    echo -e "${GREEN}✓${NC} OpenGL Vendor: $opengl_vendor"
    echo -e "${GREEN}✓${NC} OpenGL Version: $opengl_version"
    echo -e "${GREEN}✓${NC} OpenGL Renderer: $opengl_renderer"
else
    echo -e "${YELLOW}?${NC} OpenGL: ${YELLOW}glxinfo not available${NC}"
fi

# Check Vulkan
if command_exists vulkaninfo; then
    vulkan_version=$(vulkaninfo --summary 2>/dev/null | grep "Vulkan API" | head -1 | cut -d: -f2 | xargs || echo "Unknown")
    if [ "$vulkan_version" != "Unknown" ]; then
        echo -e "${GREEN}✓${NC} Vulkan: $vulkan_version"
    else
        echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}Available but no version info${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}vulkaninfo not available${NC}"
fi

# =============================================================================
# SECURITY & PERFORMANCE
# =============================================================================
print_header "SECURITY & PERFORMANCE"

# Check firewall
if systemctl is-active firewalld >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (firewalld)${NC}"
elif systemctl is-active ufw >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (ufw)${NC}"
elif iptables -L 2>/dev/null | grep -q -E "(Chain INPUT|Chain FORWARD|Chain OUTPUT)" && ! iptables -L 2>/dev/null | grep -q "Chain INPUT (policy ACCEPT)"; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (iptables)${NC}"
else
    echo -e "${YELLOW}!${NC} Firewall: ${YELLOW}No active rules detected${NC}"
fi

# Check swap
if swapon --show 2>/dev/null | grep -q .; then
    swap_usage=$(free -h | awk 'NR==3 {print $3 "/" $2 " (" $3/$2 * 100 "%)"}')
    echo -e "${GREEN}✓${NC} Swap: ${GREEN}$swap_usage used${NC}"
else
    echo -e "${BLUE}ℹ${NC} Swap: ${BLUE}Not active${NC}"
fi

# Check for system updates
if command_exists nixos-rebuild; then
    echo -e "${BLUE}ℹ${NC} System Updates: ${BLUE}Check with 'sudo nixos-rebuild dry-activate'${NC}"
fi

# =============================================================================
# APPLICATION CHECK
# =============================================================================
print_header "APPLICATIONS"

# Check key applications
apps=("firefox" "dolphin" "kate" "konsole" "chromium" "okular" "gimp" "vlc" "code" "spotify" "discord")
for app in "${apps[@]}"; do
    if command_exists "$app"; then
        echo -e "${GREEN}✓${NC} $app: ${GREEN}Available${NC}"
    else
        echo -e "${BLUE}ℹ${NC} $app: ${BLUE}Not available${NC}"
    fi
done

# =============================================================================
# ERROR CHECK
# =============================================================================
print_header "SYSTEM HEALTH"

# Use the improved function to check journal errors
check_journal_errors

# Check X11 errors
if [ -f "/var/log/Xorg.0.log" ]; then
    xerrors=$(grep -c "(EE)" /var/log/Xorg.0.log 2>/dev/null || echo "0")
    if [ "$xerrors" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} X11 Logs: ${GREEN}No errors found${NC}"
    else
        echo -e "${YELLOW}!${NC} X11 Logs: ${YELLOW}$xerrors errors found${NC}"
    fi
fi

# Check failed systemd services
failed_services=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [ "$failed_services" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Systemd Services: ${GREEN}No failed services${NC}"
else
    echo -e "${RED}!${NC} Systemd Services: ${RED}$failed_services failed services${NC}"
    systemctl --failed --no-legend 2>/dev/null | while read -r service; do
        echo -e "  ${RED}-${NC} $service"
    done
fi

# Check failed user services
if [ "$EUID" -ne 0 ]; then
    failed_user_services=$(systemctl --user --failed --no-legend 2>/dev/null | wc -l)
    if [ "$failed_user_services" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} User Services: ${GREEN}No failed services${NC}"
    else
        echo -e "${RED}!${NC} User Services: ${RED}$failed_user_services failed services${NC}"
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
echo "  Failed services: systemctl --failed"
if [ -n "$LOG_FILE" ]; then
    echo "  Log file: $LOG_FILE"
fi
echo "================================================================"

# Exit with appropriate code
if [ "${failed_services:-0}" -gt 0 ]; then
    exit 1
elif [ "${JOURNAL_ERRORS:-0}" -gt 0 ]; then
    exit 1
else
    exit 0
fi
