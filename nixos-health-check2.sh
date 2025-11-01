#!/bin/bash

# =============================================================================
# NIXOS SYSTEM HEALTH CHECK SCRIPT
# =============================================================================
# Comprehensive system status check for NixOS with NVIDIA, KDE Plasma, and Qt6
# Fully corrected version: safe, ShellCheck-compliant, robust
# =============================================================================

set -euo pipefail  # Exit on error, undefined variables, and propagate pipeline failures

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo
    echo -e "${PURPLE}=== $1 ===${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_service() {
    local service_name=$1
    local display_name=$2
    local status
    status=$(systemctl is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        active)
            echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
            ;;
        inactive)
            echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
            ;;
        failed)
            echo -e "${RED}✗${NC} $display_name: ${RED}Failed${NC}"
            ;;
        not-found)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}Not installed${NC}"
            ;;
        *)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
            ;;
    esac
}

check_user_service() {
    local service_name=$1
    local display_name=$2
    local status
    status=$(systemctl --user is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        active)
            echo -e "${GREEN}✓${NC} $display_name: ${GREEN}Running${NC}"
            ;;
        inactive)
            echo -e "${RED}✗${NC} $display_name: ${RED}Not running${NC}"
            ;;
        failed)
            echo -e "${RED}✗${NC} $display_name: ${RED}Failed${NC}"
            ;;
        not-found)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}Not installed${NC}"
            ;;
        *)
            echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}$status${NC}"
            ;;
    esac
}

check_nvidia_hybrid() {
    if lspci 2>/dev/null | grep -q "NVIDIA"; then
        echo -e "${GREEN}✓${NC} NVIDIA GPU: ${GREEN}Hardware detected${NC}"

        if [[ -f "/run/opengl-driver/lib/libGLX_nvidia.so.0" ]] || [[ -f "/run/opengl-driver-32/lib/libGLX_nvidia.so.0" ]]; then
            echo -e "${GREEN}✓${NC} NVIDIA OpenGL: ${GREEN}Available for offloading${NC}"
        fi

        if systemctl --user is-active nvidia-powerd >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} NVIDIA Power Management: ${GREEN}Active${NC}"
        fi
    else
        echo -e "${YELLOW}?${NC} NVIDIA GPU: ${YELLOW}No NVIDIA hardware detected${NC}"
    fi
}

check_journal_errors() {
    local errors=0
    local warnings=0

    if journalctl --since "1 hour ago" -p 3 &>/dev/null; then
        errors=$(journalctl --since "1 hour ago" -p 3 2>/dev/null | grep -cE "ERROR|FAILED" || echo 0)
    fi
    if journalctl --since "1 hour ago" -p 4 &>/dev/null; then
        warnings=$(journalctl --since "1 hour ago" -p 4 2>/dev/null | grep -c "WARNING" || echo 0)
    fi

    errors=$((errors + 0))
    warnings=$((warnings + 0))

    if [[ "$errors" -eq 0 && "$warnings" -eq 0 ]]; then
        echo -e "${GREEN}✓${NC} System Logs: ${GREEN}No recent errors or warnings${NC}"
    elif [[ "$errors" -eq 0 ]]; then
        echo -e "${YELLOW}!${NC} System Logs: ${YELLOW}$warnings warnings - no errors${NC}"
    else
        echo -e "${RED}!${NC} System Logs: ${RED}$errors errors, $warnings warnings in last hour${NC}"
    fi

    JOURNAL_ERRORS=$errors
    JOURNAL_WARNINGS=$warnings
}

# =============================================================================
# SYSTEM CHECK PRELIMINARIES
# =============================================================================

if [[ ! -f "/etc/NIXOS" ]]; then
    echo -e "${RED}Error: This script is designed for NixOS systems only.${NC}"
    exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
    echo -e "${YELLOW}Warning: Running as root, some user services may not be detectable.${NC}"
fi

LOG_FILE=""
if [[ "${1:-}" == "--log" ]] && [[ -n "${2:-}" ]]; then
    LOG_FILE="$2"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi

# =============================================================================
# HEADER
# =============================================================================

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
# NIXOS SPECIFIC
# =============================================================================

print_header "NIXOS SPECIFIC"

if command_exists nixos-rebuild; then
    current_gen=$(nixos-rebuild list-generations 2>/dev/null | awk '/current/ {print; exit}')
    if [[ -n "$current_gen" ]]; then
        echo -e "${GREEN}✓${NC} Current Generation: ${GREEN}$current_gen${NC}"
    else
        current_gen=$(nixos-rebuild list-generations 2>/dev/null | tail -1)
        echo -e "${BLUE}ℹ${NC} Current Generation: ${BLUE}$current_gen${NC}"
    fi
fi

if [[ -f "/etc/nixos/flake.nix" ]] || [[ -d "/etc/nixos/flake.nix" ]]; then
    echo -e "${GREEN}✓${NC} System: ${GREEN}Flake-based configuration${NC}"
else
    echo -e "${BLUE}ℹ${NC} System: ${BLUE}Traditional configuration${NC}"
fi

if command_exists nix-channel; then
    channel_list=$(nix-channel --list 2>/dev/null)
    if [[ -n "$channel_list" ]]; then
        echo -e "${GREEN}✓${NC} Nix Channels: ${GREEN}Configured${NC}"
        while IFS= read -r channel; do
            echo -e "  ${CYAN}-${NC} $channel"
        done <<< "$channel_list"
    else
        echo -e "${YELLOW}?${NC} Nix Channels: ${YELLOW}None configured${NC}"
    fi
fi

if command_exists nix; then
    nix_version=$(nix --version | head -1)
    echo -e "${GREEN}✓${NC} $nix_version"
fi

# =============================================================================
# DISPLAY & GRAPHICS
# =============================================================================

print_header "DISPLAY & GRAPHICS"

check_service "display-manager" "Display Manager"
check_service "sddm" "SDDM Display Manager"

if pgrep -x "Xorg" >/dev/null; then
    echo -e "${GREEN}✓${NC} X11 Server: ${GREEN}Running${NC}"
    [[ -n "$DISPLAY" ]] && echo -e "${BLUE}ℹ${NC} X11 Display: ${BLUE}$DISPLAY${NC}"
elif pgrep -x "wayland" >/dev/null || pgrep -f "wayland" >/dev/null; then
    echo -e "${GREEN}✓${NC} Wayland: ${GREEN}Running${NC}"
else
    echo -e "${RED}✗${NC} Display Server: ${RED}Not running${NC}"
fi

if pgrep -x "plasmashell" >/dev/null; then
    echo -e "${GREEN}✓${NC} KDE Plasma: ${GREEN}Running${NC}"
    if command_exists kf5-config; then
        kde_version=$(kf5-config --version | grep "KDE Frameworks" | awk '{print $2}')
        echo -e "${BLUE}ℹ${NC} KDE Frameworks: ${BLUE}$kde_version${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} KDE Plasma: ${YELLOW}Not detected${NC}"
fi

# NVIDIA checks
print_header "NVIDIA GRAPHICS"
check_nvidia_hybrid
nvidia_modules=$(lsmod 2>/dev/null | grep -c '^nvidia' || echo 0)
if [[ "$nvidia_modules" -ge 4 ]]; then
    echo -e "${GREEN}✓${NC} NVIDIA Modules: ${GREEN}$nvidia_modules loaded${NC}"
elif [[ "$nvidia_modules" -gt 0 ]]; then
    echo -e "${YELLOW}?${NC} NVIDIA Modules: ${YELLOW}$nvidia_modules loaded (partial)${NC}"
else
    echo -e "${RED}✗${NC} NVIDIA Modules: ${RED}None loaded${NC}"
fi

# =============================================================================
# SYSTEM LOGS
# =============================================================================

print_header "SYSTEM LOGS"
check_journal_errors

# =============================================================================
# USER SERVICES
# =============================================================================

print_header "USER SERVICES"
check_user_service "bluetooth" "Bluetooth"
check_user_service "pipewire" "PipeWire Audio"
check_user_service "networkmanager" "NetworkManager"

# =============================================================================
# NETWORK
# =============================================================================

print_header "NETWORK"
if command_exists ip; then
    ip addr show | grep -v "127.0.0.1" | grep -w "inet" | while IFS= read -r line; do
        echo -e "  ${CYAN}-${NC} $line"
    done
fi

if command_exists ping; then
    if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Internet: ${GREEN}Reachable${NC}"
    else
        echo -e "${RED}✗${NC} Internet: ${RED}Unreachable${NC}"
    fi
fi

# =============================================================================
# FINAL
# =============================================================================

echo
echo "================================================================"
echo -e "${GREEN}Health Check Complete${NC}"
echo "================================================================"
