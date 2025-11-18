#!/bin/bash

# =============================================================================
# NIXOS SYSTEM HEALTH CHECK - ENHANCED DIAGNOSTIC SCRIPT
# =============================================================================
#
# ENHANCEMENTS:
# - Fixed all arithmetic errors and improved number handling
# - Better error handling and validation
# - Enhanced performance metrics
# - More accurate service detection
# - Improved visual presentation
# - Added system scoring and recommendations
# =============================================================================

set -eu  # Fail-fast error handling

# =============================================================================
# ENHANCED COLOR SCHEME
# =============================================================================
RED='\033[0;31m'      # Critical errors
GREEN='\033[0;32m'    # Success/healthy
YELLOW='\033[1;33m'   # Warnings
BLUE='\033[0;34m'     # Information
PURPLE='\033[0;35m'   # Section headers
CYAN='\033[0;36m'     # Details
ORANGE='\033[0;33m'   # Performance metrics
NC='\033[0m'          # No color

# =============================================================================
# GLOBAL METRICS & SCORING
# =============================================================================
JOURNAL_ERRORS=0
FAILED_SERVICES_COUNT=0
SYSTEM_SCORE=100
WARNINGS=0
ERRORS=0

# =============================================================================
# ENHANCED HELPER FUNCTIONS
# =============================================================================

# Safe numeric conversion
to_number() {
    local value="$1"
    # Remove all non-numeric characters except minus and period
    value=$(echo "$value" | sed 's/[^0-9.-]*//g')
    # Handle empty values
    if [ -z "$value" ]; then
        echo "0"
    else
        echo "$value"
    fi
}

# Safe arithmetic comparison
is_greater() {
    local a=$(to_number "$1")
    local b=$(to_number "$2")
    [ "$a" -gt "$b" ]
}

# Print section headers with better visual design
print_header() {
    echo
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║ $1 ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# Print status with consistent formatting
print_status() {
    local status="$1"
    local message="$2"

    case "$status" in
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ; WARNINGS=$((WARNINGS + 1)) ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ; ERRORS=$((ERRORS + 1)) ;;
        "INFO") echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "PERFORMANCE") echo -e "${ORANGE}📊 $message${NC}" ;;
    esac
}

# Enhanced service checking
check_service() {
    local service_name=$1
    local display_name=$2
    local importance=${3:-"normal"}  # critical, important, normal

    if ! systemctl is-enabled "$service_name" >/dev/null 2>&1; then
        print_status "INFO" "$display_name: Not enabled"
        return
    fi

    local status
    status=$(systemctl is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        "active")
            print_status "SUCCESS" "$display_name: Running"
            ;;
        "inactive")
            if [ "$importance" = "critical" ]; then
                print_status "ERROR" "$display_name: Not running (CRITICAL)"
                SYSTEM_SCORE=$((SYSTEM_SCORE - 10))
            else
                print_status "WARNING" "$display_name: Not running"
                SYSTEM_SCORE=$((SYSTEM_SCORE - 2))
            fi
            ;;
        "failed")
            print_status "ERROR" "$display_name: Failed"
            SYSTEM_SCORE=$((SYSTEM_SCORE - 5))
            FAILED_SERVICES_COUNT=$((FAILED_SERVICES_COUNT + 1))
            ;;
        "not-found")
            print_status "INFO" "$display_name: Not installed"
            ;;
        *)
            print_status "WARNING" "$display_name: Unknown status ($status)"
            ;;
    esac
}

# Enhanced user service checking
check_user_service() {
    local service_name=$1
    local display_name=$2

    if [ "$EUID" -eq 0 ]; then
        print_status "INFO" "$display_name: Skipped (running as root)"
        return
    fi

    if ! systemctl --user is-enabled "$service_name" >/dev/null 2>&1; then
        print_status "INFO" "$display_name: Not enabled"
        return
    fi

    local status
    status=$(systemctl --user is-active "$service_name" 2>/dev/null || echo "not-found")

    case "$status" in
        "active") print_status "SUCCESS" "$display_name: Running" ;;
        "inactive") print_status "WARNING" "$display_name: Not running" ;;
        "failed")
            print_status "ERROR" "$display_name: Failed"
            FAILED_SERVICES_COUNT=$((FAILED_SERVICES_COUNT + 1))
            ;;
        "not-found") print_status "INFO" "$display_name: Not installed" ;;
        *) print_status "WARNING" "$display_name: Unknown status ($status)" ;;
    esac
}

# Command existence check
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# =============================================================================
# ENHANCED DIAGNOSTIC FUNCTIONS
# =============================================================================

# Improved NVIDIA diagnostics
check_nvidia_hybrid() {
    if lspci 2>/dev/null | grep -q "NVIDIA"; then
        print_status "SUCCESS" "NVIDIA GPU: Hardware detected"

        # Check NVIDIA OpenGL driver availability
        if [ -f "/run/opengl-driver/lib/libGLX_nvidia.so.0" ] || [ -f "/run/opengl-driver-32/lib/libGLX_nvidia.so.0" ]; then
            print_status "SUCCESS" "NVIDIA OpenGL: Available for offloading"
        fi

        # Check NVIDIA power management
        if systemctl --user is-active nvidia-powerd >/dev/null 2>&1; then
            print_status "SUCCESS" "NVIDIA Power Management: Active"
        fi

        # Check if NVIDIA modules are loaded
        local nvidia_modules
        nvidia_modules=$(lsmod | grep -c nvidia || true)
        if [ "$nvidia_modules" -ge 4 ]; then
            print_status "SUCCESS" "NVIDIA Modules: $nvidia_modules loaded"
        else
            print_status "WARNING" "NVIDIA Modules: $nvidia_modules loaded (may be incomplete)"
        fi
    else
        print_status "INFO" "NVIDIA GPU: No NVIDIA hardware detected"
    fi
}

# Enhanced journal error analysis
check_journal_errors() {
    local errors=0
    local warnings=0

    if command_exists journalctl; then
        # Get errors from journal (priority 3)
        local error_output
        error_output=$(journalctl --since "1 hour ago" -p 3 --no-pager 2>/dev/null | grep -c "ERROR\|FAILED" 2>/dev/null || echo "0")
        errors=$(to_number "$error_output")

        # Get warnings from journal (priority 4)
        local warning_output
        warning_output=$(journalctl --since "1 hour ago" -p 4 --no-pager 2>/dev/null | grep -c "WARNING" 2>/dev/null || echo "0")
        warnings=$(to_number "$warning_output")
    fi

    if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
        print_status "SUCCESS" "System Logs: No errors or warnings in last hour"
    elif [ "$errors" -eq 0 ]; then
        print_status "WARNING" "System Logs: $warnings warnings (no errors) in last hour"
        SYSTEM_SCORE=$((SYSTEM_SCORE - 1))
    else
        print_status "ERROR" "System Logs: $errors errors, $warnings warnings in last hour"
        SYSTEM_SCORE=$((SYSTEM_SCORE - errors))
        JOURNAL_ERRORS=$errors
    fi
}

# Enhanced Nix store analysis
check_nix_store() {
    if command_exists nix-store; then
        echo -e "${CYAN}📦 Nix Store Analysis:${NC}"

        local store_size
        store_size=$(du -sh /nix/store 2>/dev/null | cut -f1 || echo "Unknown")
        local store_items
        store_items=$(find /nix/store -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")
        store_items=$(to_number "$store_items")

        echo -e "  ${CYAN}├─${NC} Store Size: $store_size"
        echo -e "  ${CYAN}├─${NC} Store Items: $store_items"

        if [ -d "/nix/store" ] && [ "$store_items" -gt 1000 ]; then
            print_status "SUCCESS" "Store Integrity: Basic check passed"
        else
            print_status "WARNING" "Store Integrity: Basic check questionable"
        fi
    fi
}

# Enhanced security audit
check_security_hardening() {
    echo -e "${CYAN}🔒 Security Hardening:${NC}"

    # Firewall check
    if systemctl is-active firewalld >/dev/null 2>&1; then
        print_status "SUCCESS" "Firewall: firewalld active"
    elif systemctl is-active ufw >/dev/null 2>&1; then
        print_status "SUCCESS" "Firewall: ufw active"
    elif command_exists iptables && iptables -L INPUT 2>/dev/null | grep -q "DROP"; then
        print_status "SUCCESS" "Firewall: iptables with DROP policies"
    else
        print_status "WARNING" "Firewall: No active rules detected"
        SYSTEM_SCORE=$((SYSTEM_SCORE - 5))
    fi

    # SSH security check
    local failed_ssh=0
    if systemctl is-active ssh >/dev/null 2>&1 || systemctl is-active sshd >/dev/null 2>&1; then
        local ssh_output
        ssh_output=$(journalctl -u ssh -u sshd --since "1 hour ago" 2>/dev/null | grep -c "Failed password" || echo "0")
        failed_ssh=$(to_number "$ssh_output")
    fi

    if [ "$failed_ssh" -gt 0 ]; then
        print_status "WARNING" "SSH Security: $failed_ssh failed attempts in last hour"
    else
        print_status "SUCCESS" "SSH Security: No recent failed attempts"
    fi

    # Swap encryption check
    if command_exists swapon && swapon --show 2>/dev/null | grep -q "/dev/mapper"; then
        print_status "SUCCESS" "Swap Encryption: Encrypted swap detected"
    else
        print_status "INFO" "Swap Encryption: Not encrypted"
    fi
}

# Enhanced memory performance
check_memory_performance() {
    echo -e "${CYAN}🧠 Memory Performance:${NC}"

    # Memory pressure from PSI
    local pressure=0
    if [ -f "/proc/pressure/memory" ]; then
        local pressure_line
        pressure_line=$(grep "some" /proc/pressure/memory 2>/dev/null | head -1 || echo "")
        if [ -n "$pressure_line" ]; then
            # Extract the 10s average pressure (third field)
            local pressure_value
            pressure_value=$(echo "$pressure_line" | awk '{print $3}' | cut -d. -f1)
            pressure=$(to_number "$pressure_value")
        fi
    fi

    # Convert pressure percentage (it's already 0-100)
    if [ "$pressure" -gt 50 ]; then
        print_status "ERROR" "Memory Pressure: ${pressure}% (very high)"
        SYSTEM_SCORE=$((SYSTEM_SCORE - 10))
    elif [ "$pressure" -gt 25 ]; then
        print_status "WARNING" "Memory Pressure: ${pressure}% (high)"
        SYSTEM_SCORE=$((SYSTEM_SCORE - 5))
    elif [ "$pressure" -gt 10 ]; then
        print_status "WARNING" "Memory Pressure: ${pressure}% (moderate)"
        SYSTEM_SCORE=$((SYSTEM_SCORE - 2))
    else
        print_status "SUCCESS" "Memory Pressure: ${pressure}% (normal)"
    fi

    # OOM kills check
    local oom_kills=0
    if command_exists dmesg; then
        local oom_output
        oom_output=$(dmesg 2>/dev/null | grep -c "killed process" || echo "0")
        oom_kills=$(to_number "$oom_output")
    fi

    if [ "$oom_kills" -gt 0 ]; then
        print_status "ERROR" "OOM Kills: $oom_kills processes killed"
        SYSTEM_SCORE=$((SYSTEM_SCORE - oom_kills * 5))
    fi
}

# Enhanced storage performance
check_storage_performance() {
    echo -e "${CYAN}💾 Storage Performance:${NC}"

    # SMART status check
    if command_exists smartctl; then
        for disk in /dev/nvme0n1 /dev/sda /dev/sdb; do
            if [ -b "$disk" ]; then
                local health
                health=$(smartctl -H "$disk" 2>/dev/null | grep -i "health" | cut -d: -f2 | xargs || echo "UNKNOWN")
                if [ "$health" = "PASSED" ] || [ "$health" = "OK" ]; then
                    print_status "SUCCESS" "$disk Health: $health"
                else
                    print_status "WARNING" "$disk Health: $health"
                fi
            fi
        done
    fi

    # Disk scheduler information
    for disk in /sys/block/sd* /sys/block/nvme*; do
        if [ -d "$disk" ]; then
            local disk_name
            disk_name=$(basename "$disk")
            if [ -f "$disk/queue/scheduler" ]; then
                local scheduler
                scheduler=$(grep -o "\\[.*\\]" "$disk/queue/scheduler" 2>/dev/null | tr -d "[]" || echo "unknown")
                echo -e "  ${CYAN}├─${NC} $disk_name Scheduler: $scheduler"
            fi
        fi
    done
}

# Enhanced gaming ecosystem
check_gaming_ecosystem() {
    echo -e "${CYAN}🎮 Gaming Ecosystem:${NC}"

    # Steam detection
    if [ -d "$HOME/.steam" ] || command_exists steam; then
        print_status "SUCCESS" "Steam: Installed"

        # Proton versions
        local proton_dirs=("$HOME/.steam/steam/steamapps/common/Proton"*)
        if [ -e "${proton_dirs[0]}" ]; then
            local proton_versions
            proton_versions=$(find "$HOME/.steam/steam/steamapps/common/" -maxdepth 1 -name "Proton*" -type d 2>/dev/null | wc -l)
            proton_versions=$(to_number "$proton_versions")
            echo -e "  ${CYAN}├─${NC} Proton Versions: $proton_versions"
        fi
    else
        print_status "INFO" "Steam: Not installed"
    fi

    # GameMode status
    if systemctl --user is-active gamemoded >/dev/null 2>&1; then
        print_status "SUCCESS" "GameMode: Active"
    else
        print_status "INFO" "GameMode: Not active"
    fi

    # Gaming peripherals
    if command_exists lsusb && lsusb 2>/dev/null | grep -q -i "gamepad\\|joystick\\|SteelSeries\\|Logitech.*Game"; then
        print_status "SUCCESS" "Gaming Peripherals: Detected"
    else
        print_status "INFO" "Gaming Peripherals: None detected"
    fi
}

# =============================================================================
# SYSTEM SCORING AND RECOMMENDATIONS
# =============================================================================

calculate_system_score() {
    # Deduct points based on issues found
    if [ "$FAILED_SERVICES_COUNT" -gt 0 ]; then
        SYSTEM_SCORE=$((SYSTEM_SCORE - FAILED_SERVICES_COUNT * 5))
    fi

    if [ "$JOURNAL_ERRORS" -gt 10 ]; then
        SYSTEM_SCORE=$((SYSTEM_SCORE - 10))
    elif [ "$JOURNAL_ERRORS" -gt 0 ]; then
        SYSTEM_SCORE=$((SYSTEM_SCORE - 5))
    fi

    # Ensure score doesn't go below 0
    if [ "$SYSTEM_SCORE" -lt 0 ]; then
        SYSTEM_SCORE=0
    elif [ "$SYSTEM_SCORE" -gt 100 ]; then
        SYSTEM_SCORE=100
    fi
}

print_recommendations() {
    local recommendations=()

    if [ "$FAILED_SERVICES_COUNT" -gt 0 ]; then
        recommendations+=("Check failed services: systemctl --failed")
    fi

    if [ "$JOURNAL_ERRORS" -gt 0 ]; then
        recommendations+=("Review system logs: journalctl -p 3 -xb")
    fi

    if ! systemctl is-active firewalld >/dev/null 2>&1 && ! systemctl is-active ufw >/dev/null 2>&1; then
        recommendations+=("Consider enabling a firewall")
    fi

    local nix_gen_count
    nix_gen_count=$(nixos-rebuild list-generations 2>/dev/null | wc -l)
    nix_gen_count=$(to_number "$nix_gen_count")
    if [ "$nix_gen_count" -gt 20 ]; then
        recommendations+=("Clean up old generations: sudo nix-collect-garbage -d")
    fi

    if [ ${#recommendations[@]} -gt 0 ]; then
        echo
        print_header "RECOMMENDATIONS"
        for recommendation in "${recommendations[@]}"; do
            echo -e "  ${YELLOW}•${NC} $recommendation"
        done
    fi
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

# Trap for clean interruption
trap 'echo -e "\n${YELLOW}Diagnostics interrupted...${NC}"; exit 1' INT TERM

# NixOS validation
if [ ! -f "/etc/NIXOS" ]; then
    echo -e "${RED}❌ Error: This script is designed for NixOS systems only.${NC}"
    exit 1
fi

# Logging setup
LOG_FILE=""
if [ "${1:-}" = "--log" ] && [ -n "${2:-}" ]; then
    LOG_FILE="$2"
    exec > >(tee -a "$LOG_FILE") 2>&1
fi

# System header with better design
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                   NIXOS SYSTEM HEALTH CHECK                 ║"
echo "║                   ENHANCED DIAGNOSTICS                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${BLUE}System:${NC} $(nixos-version 2>/dev/null || echo "Unknown")"
echo -e "${BLUE}Kernel:${NC} $(uname -r)"
echo -e "${BLUE}User:${NC} $(whoami)@$(hostname)"
echo -e "${BLUE}Date:${NC} $(date)"
echo -e "${BLUE}Uptime:${NC} $(uptime -p 2>/dev/null | sed 's/up //' || uptime | sed 's/.*up //' | sed 's/,.*//')"

# =============================================================================
# EXECUTE DIAGNOSTIC SECTIONS
# =============================================================================

print_header "SYSTEM CORE HEALTH"
check_journal_errors
check_service "NetworkManager" "Network Manager" "important"
check_service "dbus" "D-Bus System Bus" "critical"

print_header "GRAPHICS & DISPLAY"
check_service "display-manager" "Display Manager" "important"
check_nvidia_hybrid

print_header "AUDIO SYSTEM"
check_user_service "pipewire" "PipeWire Audio"
check_user_service "pipewire-pulse" "PipeWire PulseAudio"
check_user_service "wireplumber" "WirePlumber Session Manager"

print_header "SYSTEM SERVICES"
check_service "docker" "Docker Service"
check_service "cups" "Printing Service"
check_service "tlp" "Power Management"
check_service "fstrim.timer" "SSD Trim Timer"
check_service "avahi-daemon" "Network Discovery"
check_service "fwupd" "Firmware Updates"
check_service "thermald" "Thermal Management"

print_header "SYSTEM RESOURCES"
check_storage_performance
check_memory_performance

print_header "SECURITY AUDIT"
check_security_hardening

print_header "USER ENVIRONMENT"
check_service "bluetooth" "Bluetooth Service"
check_gaming_ecosystem

print_header "NIXOS SPECIFICS"
check_nix_store

# =============================================================================
# FINAL ASSESSMENT
# =============================================================================

calculate_system_score

print_header "SYSTEM HEALTH ASSESSMENT"

# Final service status
FAILED_SERVICES_COUNT=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
FAILED_SERVICES_COUNT=$(to_number "$FAILED_SERVICES_COUNT")

if [ "$FAILED_SERVICES_COUNT" -eq 0 ]; then
    print_status "SUCCESS" "Systemd Services: No failed services"
else
    print_status "ERROR" "Systemd Services: $FAILED_SERVICES_COUNT failed services"
    systemctl --failed --no-legend 2>/dev/null | while read -r service; do
        echo -e "    ${RED}├─${NC} $service"
    done
fi

# System score visualization
echo
echo -e "${CYAN}System Health Score: ${NC}"
if [ "$SYSTEM_SCORE" -ge 90 ]; then
    echo -e "  ${GREEN}██████████ $SYSTEM_SCORE/100 - EXCELLENT${NC}"
elif [ "$SYSTEM_SCORE" -ge 70 ]; then
    echo -e "  ${YELLOW}████████░░ $SYSTEM_SCORE/100 - GOOD${NC}"
elif [ "$SYSTEM_SCORE" -ge 50 ]; then
    echo -e "  ${ORANGE}██████░░░░ $SYSTEM_SCORE/100 - FAIR${NC}"
else
    echo -e "  ${RED}████░░░░░░ $SYSTEM_SCORE/100 - NEEDS ATTENTION${NC}"
fi

echo -e "  ${CYAN}Issues Found:${NC} $ERRORS errors, $WARNINGS warnings"

# Recommendations
print_recommendations

# Final summary
echo
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     DIAGNOSTICS COMPLETE                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"

if [ "$SYSTEM_SCORE" -ge 80 ]; then
    echo -e "${GREEN}✅ Your system is in good health!${NC}"
elif [ "$SYSTEM_SCORE" -ge 60 ]; then
    echo -e "${YELLOW}⚠️  Your system has some issues that need attention.${NC}"
else
    echo -e "${RED}❌ Your system needs immediate attention!${NC}"
fi

if [ -n "$LOG_FILE" ]; then
    echo -e "${BLUE}📋 Full diagnostic log saved to: $LOG_FILE${NC}"
fi

# Exit code based on system health
if [ "$ERRORS" -gt 0 ] || [ "$SYSTEM_SCORE" -lt 60 ]; then
    exit 1
else
    exit 0
fi
