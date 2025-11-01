#!/bin/bash

# =============================================================================
# NIXOS SYSTEM HEALTH CHECK - MASTER DIAGNOSTIC SCRIPT
# =============================================================================
#
# 🎯 HEALTH CHECK VISION:
# "En omfattende systemdiagnostik der afslører maskinens helbred og ydeevne
# i realtid - fra kernel til brugeroplevelse"
#
# 🔧 DIAGNOSTIC PHILOSOPHY:
# "Proaktiv systemovervågning der identificerer problemer før de bliver kritiske,
# og validerer at alle komponenter arbejder i perfekt harmoni"
#
# 🚀 KERNETEKNOLOGIER:
# - Systemd Service Intelligence: Dyb integritetskontrol af alle tjenester
# - NVIDIA Hybrid Graphics Analysis: Fuldt GPU økosystem diagnosticering
# - PipeWire Audio Verification: Lydstack validering fra kernel til applikation
# - Network Ecosystem Mapping: Komplet netværks tilstandskartotek
# =============================================================================

set -eu  # 🛡️ Fail-fast error handling: Exit on error and undefined variables

# =============================================================================
# TERMINAL FARVE KONFIGURATION - DIAGNOSTIKENS PERSONLIGHED
# =============================================================================
#
# 🎨 COLOR STRATEGY:
# "Visuel hierarki der guider øjet til kritiske informationer"
#
RED='\033[0;31m'      # 🔴 Kritisk: Fejl og advarsler
GREEN='\033[0;32m'    # 🟢 Succes: Funktionelle komponenter
YELLOW='\033[1;33m'   # 🟡 Warning: Delvise eller potentielle problemer
BLUE='\033[0;34m'     # 🔵 Information: System status og data
PURPLE='\033[0;35m'   # 🟣 Sektioner: Overskrifter og kategorier
CYAN='\033[0;36m'     # 🟢 Details: Underordnede informationer
NC='\033[0m'          # 🔄 Reset: Nulstil terminal farver

# =============================================================================
# GLOBAL VARIABLER - DIAGNESTISKE METRIKKER
# =============================================================================
#
# 📊 METRIC STRATEGY:
# "Kvantificer systemtilstand for automatiseret helbredsvurdering"
#
JOURNAL_ERRORS=0

# =============================================================================
# DIAGNOSTIC FUNKTIONER - SYSTEMETS ANALYSE VÆRKTØJER
# =============================================================================

# -----------------------------------------------------------------------------
# SEKTIONS HEADER - DIAGNOSTISK KATEGORI VISUALISERING
# -----------------------------------------------------------------------------
#
print_header() {
    echo
    echo -e "${PURPLE}=== $1 ===${NC}"
    # 🎯 Header Mission: "Klar adskillelse af diagnostiske domæner"
}

# -----------------------------------------------------------------------------
# SERVICE STATUS CHECK - SYSTEM TJENESTE LIVSTEGN
# -----------------------------------------------------------------------------
#
check_service() {
    local service_name=$1
    local display_name=$2
    local status
    status=$(systemctl is-active "$service_name" 2>/dev/null || echo "not-found")

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
    # 🎯 Service Check Rationale: "Identificer failed services før de påvirker brugeren"
}

# -----------------------------------------------------------------------------
# USER SERVICE CHECK - BRUGER MILJØ TJENESTER
# -----------------------------------------------------------------------------
#
check_user_service() {
    local service_name=$1
    local display_name=$2

    # Skip user service checks when running as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${YELLOW}?${NC} $display_name: ${YELLOW}Not checked (running as root)${NC}"
        return
    fi

    local status
    status=$(systemctl --user is-active "$service_name" 2>/dev/null || echo "not-found")

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
    # 🎯 User Service Mission: "Valider bruger-session tjenester for uafbrudt arbejdsflow"
}

# -----------------------------------------------------------------------------
# COMMAND EXISTENCE VERIFICATION - VÆRKTØJS TILGÆNGELIGHED
# -----------------------------------------------------------------------------
#
command_exists() {
    command -v "$1" >/dev/null 2>&1
    # 🔧 Function Purpose: "Sikrer at diagnostiske værktøjer er tilgængelige"
}

# -----------------------------------------------------------------------------
# NVIDIA HYBRID GRAPHICS DIAGNOSTIC - DUAL GPU ØKOSYSTEM
# -----------------------------------------------------------------------------
#
check_nvidia_hybrid() {
    if lspci 2>/dev/null | grep -q "NVIDIA"; then
        echo -e "${GREEN}✓${NC} NVIDIA GPU: ${GREEN}Hardware detected${NC}"

        # Check NVIDIA OpenGL driver availability
        if [ -f "/run/opengl-driver/lib/libGLX_nvidia.so.0" ] || [ -f "/run/opengl-driver-32/lib/libGLX_nvidia.so.0" ]; then
            echo -e "${GREEN}✓${NC} NVIDIA OpenGL: ${GREEN}Available for offloading${NC}"
        fi

        # Validate NVIDIA power management
        if systemctl --user is-active nvidia-powerd >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} NVIDIA Power Management: ${GREEN}Active${NC}"
        fi
    else
        echo -e "${YELLOW}?${NC} NVIDIA GPU: ${YELLOW}No NVIDIA hardware detected${NC}"
    fi
    # 🎯 NVIDIA Diagnostic Mission: "Verificer at hybrid graphics arbejder optimalt"
}

# -----------------------------------------------------------------------------
# SYSTEM JOURNAL ERROR ANALYSIS - LOG BASERET FEJLDETEKTION
# -----------------------------------------------------------------------------
#
check_journal_errors() {
    local errors=0
    local warnings=0

    # 🕒 Recent Error Analysis: "Fokusér på aktuelle problemer"
    if journalctl --since "1 hour ago" -p 3 &>/dev/null; then
        errors=$(journalctl --since "1 hour ago" -p 3 2>/dev/null | grep -c "ERROR\|FAILED" 2>/dev/null || echo "0")
    fi

    if journalctl --since "1 hour ago" -p 4 &>/dev/null; then
        warnings=$(journalctl --since "1 hour ago" -p 4 2>/dev/null | grep -c "WARNING" 2>/dev/null || echo "0")
    fi

    # Convert to integers with error handling
    errors=$((errors + 0))
    warnings=$((warnings + 0))

    if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} System Logs: ${GREEN}No recent errors or warnings${NC}"
    elif [ "$errors" -eq 0 ]; then
        echo -e "${YELLOW}!${NC} System Logs: ${YELLOW}$warnings warnings - no errors${NC}"
    else
        echo -e "${RED}!${NC} System Logs: ${RED}$errors errors, $warnings warnings in last hour${NC}"
    fi

    # 📊 Error Metrics: "Kvantificer system stabilitet"
    JOURNAL_ERRORS=$errors
}

# -----------------------------------------------------------------------------
# NIX STORE INTEGRITY - PAKKE SYSTEM HELBRED
# -----------------------------------------------------------------------------
#
check_nix_store() {
    if command_exists nix-store; then
        echo -e "${CYAN}Nix Store Analysis:${NC}"

        # Store size analysis only (skip slow verify)
        local store_size
        store_size=$(du -sh /nix/store 2>/dev/null | cut -f1 || echo "Unknown")
        local store_items
        store_items=$(find /nix/store -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")
        echo -e "  ${CYAN}-${NC} Store Size: $store_size"
        echo -e "  ${CYAN}-${NC} Store Items: $store_items"

        # Quick health check without full verify
        if [ -d "/nix/store" ] && [ "$store_items" -gt 1000 ]; then
            echo -e "  ${GREEN}✓${NC} Store Integrity: ${GREEN}Basic check passed${NC}"
        else
            echo -e "  ${YELLOW}!${NC} Store Integrity: ${YELLOW}Basic check questionable${NC}"
        fi
    fi
    # 🎯 Store Mission: "Verificer Nix pakkesystemets fundamentale integritet"
}

# -----------------------------------------------------------------------------
# NIX GARBAGE COLLECTION STATUS - SYSTEM RENGØRING
# -----------------------------------------------------------------------------
#
check_nix_gc() {
    if command_exists nix-collect-garbage; then
        echo -e "${CYAN}Garbage Collection:${NC}"

        # Check when GC last ran
        if [ -f "/nix/var/nix/gc-last-run" ]; then
            local last_gc
            last_gc=$(date -d "@$(cat /nix/var/nix/gc-last-run)" 2>/dev/null || echo "Unknown")
            echo -e "  ${CYAN}-${NC} Last GC: $last_gc"
        fi

        # Check generations count
        local gen_count
        gen_count=$(nixos-rebuild list-generations 2>/dev/null | wc -l || echo "0")
        if [ "$gen_count" -gt 20 ]; then
            echo -e "  ${YELLOW}!${NC} Generations: ${YELLOW}$gen_count (consider cleanup)${NC}"
        else
            echo -e "  ${GREEN}✓${NC} Generations: ${GREEN}$gen_count${NC}"
        fi
    fi
    # 🎯 GC Mission: "Overvåg systemets oprydnings- og vedligeholdelsescyklus"
}

# -----------------------------------------------------------------------------
# SECURITY HARDENING VALIDATION - SIKKERHEDS FORSTÆRKINING
# -----------------------------------------------------------------------------
#
check_security_hardening() {
    echo -e "${CYAN}Security Hardening:${NC}"

    # Check if firewall is actually blocking
    if iptables -L INPUT 2>/dev/null | grep -q "DROP"; then
        echo -e "  ${GREEN}✓${NC} Firewall Rules: ${GREEN}Active DROP policies${NC}"
    else
        echo -e "  ${YELLOW}!${NC} Firewall Rules: ${YELLOW}No explicit DROP policies${NC}"
    fi

    # Check for failed SSH attempts
    local failed_ssh
    failed_ssh=$(journalctl -u ssh --since "1 hour ago" 2>/dev/null | grep -c "Failed password" || echo "0")
    if [ "$failed_ssh" -gt 0 ]; then
        echo -e "  ${YELLOW}!${NC} SSH Security: ${YELLOW}$failed_ssh failed attempts in last hour${NC}"
    else
        echo -e "  ${GREEN}✓${NC} SSH Security: ${GREEN}No recent failed attempts${NC}"
    fi

    # Check if swap encryption is active
    if swapon --show 2>/dev/null | grep -q "/dev/mapper"; then
        echo -e "  ${GREEN}✓${NC} Swap Encryption: ${GREEN}Encrypted swap detected${NC}"
    else
        echo -e "  ${BLUE}ℹ${NC} Swap Encryption: ${BLUE}Not encrypted${NC}"
    fi
    # 🎯 Security Mission: "Valider systemets forsvar mod eksterne trusler"
}

# -----------------------------------------------------------------------------
# STORAGE PERFORMANCE - DISK RESPONS TID
# -----------------------------------------------------------------------------
#
check_storage_performance() {
    echo -e "${CYAN}Storage Performance:${NC}"

    # Check SSD/NVMe health
    if command_exists smartctl; then
        for disk in /dev/nvme0n1 /dev/sda; do
            if [ -b "$disk" ]; then
                local health
                health=$(smartctl -H "$disk" 2>/dev/null | grep "SMART overall-health" | cut -d: -f2 | xargs || echo "UNKNOWN")
                if [ "$health" = "PASSED" ]; then
                    echo -e "  ${GREEN}✓${NC} $disk Health: ${GREEN}$health${NC}"
                else
                    echo -e "  ${YELLOW}!${NC} $disk Health: ${YELLOW}$health${NC}"
                fi
            fi
        done
    fi

    # Check I/O scheduler
    for disk in /sys/block/sd* /sys/block/nvme*; do
        if [ -d "$disk" ]; then
            local disk_name
            disk_name=$(basename "$disk")
            local scheduler
            scheduler=$(cat "$disk/queue/scheduler" 2>/dev/null | grep -o "\\[.*\\]" | tr -d "[]" || echo "unknown")
            echo -e "  ${CYAN}-${NC} $disk_name Scheduler: $scheduler"
        fi
    done
    # 🎯 Storage Mission: "Analyser diskenes sundhed og ydeevneoptimering"
}

# -----------------------------------------------------------------------------
# MEMORY PERFORMANCE - RAM EFFEKTIVITET
# -----------------------------------------------------------------------------
#
check_memory_performance() {
    echo -e "${CYAN}Memory Performance:${NC}"

    # Check for memory pressure
    local pressure
    pressure=$(cat /proc/pressure/memory 2>/dev/null | grep "some" | awk '{print $3}' | cut -d. -f1 || echo "0")
    if [ "$pressure" -gt 25 ]; then
        echo -e "  ${RED}!${NC} Memory Pressure: ${RED}$pressure% (high)${NC}"
    elif [ "$pressure" -gt 10 ]; then
        echo -e "  ${YELLOW}!${NC} Memory Pressure: ${YELLOW}$pressure% (moderate)${NC}"
    else
        echo -e "  ${GREEN}✓${NC} Memory Pressure: ${GREEN}$pressure% (low)${NC}"
    fi

    # Check for OOM killer activity
    local oom_kills
    oom_kills=$(dmesg 2>/dev/null | grep -c "killed process" || echo "0")
    if [ "$oom_kills" -gt 0 ]; then
        echo -e "  ${RED}!${NC} OOM Kills: ${RED}$oom_kills processes killed${NC}"
    fi
    # 🎯 Memory Mission: "Overvåg hukommelsesforvaltning og swap-optimering"
}

# -----------------------------------------------------------------------------
# DOCKER CONTAINER ECOSYSTEM - CONTAINER HELBRED
# -----------------------------------------------------------------------------
#
check_docker_health() {
    if command_exists docker && systemctl is-active docker >/dev/null 2>&1; then
        echo -e "${CYAN}Docker Ecosystem:${NC}"

        # Container status
        local running_containers
        running_containers=$(docker ps -q 2>/dev/null | wc -l || echo "0")
        local total_containers
        total_containers=$(docker ps -aq 2>/dev/null | wc -l || echo "0")
        echo -e "  ${CYAN}-${NC} Containers: $running_containers running / $total_containers total"

        # Docker disk usage
        local docker_disk
        docker_disk=$(docker system df 2>/dev/null | grep "Images" | awk '{print $4}' || echo "Unknown")
        echo -e "  ${CYAN}-${NC} Images Disk: $docker_disk"

        # Check for container restarts
        local restarted_containers
        restarted_containers=$(docker ps --filter "status=restarting" 2>/dev/null | wc -l || echo "0")
        if [ "$restarted_containers" -gt 0 ]; then
            echo -e "  ${YELLOW}!${NC} Container Health: ${YELLOW}$restarted_containers restarting${NC}"
        fi
    fi
    # 🎯 Docker Mission: "Monitorer container økosystemets stabilitet og ressourceforbrug"
}

# -----------------------------------------------------------------------------
# VIRTUALIZATION PERFORMANCE - KVM ACCELERATION
# -----------------------------------------------------------------------------
#
check_virtualization() {
    if systemctl is-active libvirtd >/dev/null 2>&1; then
        echo -e "${CYAN}Virtualization:${NC}"

        # Check KVM acceleration
        if [ -e "/dev/kvm" ]; then
            echo -e "  ${GREEN}✓${NC} KVM Acceleration: ${GREEN}Available${NC}"
        else
            echo -e "  ${YELLOW}!${NC} KVM Acceleration: ${YELLOW}Not available${NC}"
        fi

        # Check active VMs
        if command_exists virsh; then
            local active_vms
            active_vms=$(virsh list --state-running 2>/dev/null | grep -c "running" || echo "0")
            local total_vms
            total_vms=$(virsh list --all 2>/dev/null | grep -c "running\\|shut off" || echo "0")
            echo -e "  ${CYAN}-${NC} VMs: $active_vms active / $total_vms total"
        fi
    fi
    # 🎯 Virtualization Mission: "Valider virtualiseringsplatformens ydeevne og tilgængelighed"
}

# -----------------------------------------------------------------------------
# NETWORK PERFORMANCE - BÅNDBREDDE OG LATENCY
# -----------------------------------------------------------------------------
#
check_network_performance() {
    echo -e "${CYAN}Network Performance:${NC}"

    # Check network buffer sizes
    if [ -f "/proc/sys/net/core/rmem_max" ]; then
        local rmem
        rmem=$(cat /proc/sys/net/core/rmem_max)
        local wmem
        wmem=$(cat /proc/sys/net/core/wmem_max)
        echo -e "  ${CYAN}-${NC} Network Buffers: ${rmem}/$wmem bytes"
    fi

    # Check for network errors
    if command_exists netstat; then
        local network_errors
        network_errors=$(netstat -i 2>/dev/null | awk '{errors+=$4+$8} END {print errors}' || echo "0")
        if [ "$network_errors" -gt 0 ]; then
            echo -e "  ${YELLOW}!${NC} Network Errors: ${YELLOW}$network_errors total${NC}"
        fi
    fi

    # Check DNS resolution performance
    if command_exists dig; then
        local dns_time
        dns_time=$(dig google.com 2>/dev/null | grep "Query time:" | awk '{print $4}' || echo "0")
        echo -e "  ${CYAN}-${NC} DNS Resolution: ${dns_time}ms"
    fi
    # 🎯 Network Mission: "Mål netværkslagers ydeevne og fejlrate"
}

# -----------------------------------------------------------------------------
# KDE PLASMA SESSION HEALTH - DESKTOP STABILITET
# -----------------------------------------------------------------------------
#
check_kde_health() {
    if pgrep -x "plasmashell" > /dev/null; then
        echo -e "${CYAN}KDE Plasma Session:${NC}"

        # Check KDE crash history
        if [ -d "$HOME/.kde/crash-" ]; then
            local crash_count
            crash_count=$(find "$HOME/.kde/crash-"* -name "*.rc" 2>/dev/null | wc -l || echo "0")
            if [ "$crash_count" -gt 0 ]; then
                echo -e "  ${YELLOW}!${NC} Crash Reports: ${YELLOW}$crash_count recent crashes${NC}"
            fi
        fi

        # Check KWin compositor
        if pgrep -x "kwin_x11" > /dev/null || pgrep -x "kwin_wayland" > /dev/null; then
            echo -e "  ${GREEN}✓${NC} KWin Compositor: ${GREEN}Running${NC}"
        else
            echo -e "  ${RED}✗${NC} KWin Compositor: ${RED}Not running${NC}"
        fi

        # Check Plasma services
        local plasma_services=("kded5" "ksmserver" "kactivitymanagerd")
        for service in "${plasma_services[@]}"; do
            if pgrep -x "$service" > /dev/null; then
                echo -e "  ${GREEN}✓${NC} $service: ${GREEN}Running${NC}"
            else
                echo -e "  ${YELLOW}?${NC} $service: ${YELLOW}Not detected${NC}"
            fi
        done
    else
        echo -e "${YELLOW}?${NC} KDE Plasma Session: ${YELLOW}Not running (plasmashell not found)${NC}"
    fi
    # 🎯 KDE Mission: "Diagnosticer desktop-miljøets stabilitet og komponenttilstand"
}

# -----------------------------------------------------------------------------
# GAMING ECOSYSTEM HEALTH - SPIL YDEEVNE
# -----------------------------------------------------------------------------
#
check_gaming_ecosystem() {
    echo -e "${CYAN}Gaming Ecosystem:${NC}"

    # Check Steam installation
    if [ -d "$HOME/.steam" ] || command_exists steam; then
        echo -e "  ${GREEN}✓${NC} Steam: ${GREEN}Installed${NC}"

        # Check for Proton versions
        if [ -d "$HOME/.steam/steam/steamapps/common/Proton*" ]; then
            local proton_versions
            proton_versions=$(find "$HOME/.steam/steam/steamapps/common/" -name "Proton*" -type d 2>/dev/null | wc -l || echo "0")
            echo -e "  ${CYAN}-${NC} Proton Versions: $proton_versions"
        fi
    else
        echo -e "  ${BLUE}ℹ${NC} Steam: ${BLUE}Not installed${NC}"
    fi

    # Check gaming-related services
    if systemctl --user is-active gamemoded >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} GameMode: ${GREEN}Active${NC}"
    else
        echo -e "  ${BLUE}ℹ${NC} GameMode: ${BLUE}Not active${NC}"
    fi

    # Check for gaming peripherals
    if lsusb 2>/dev/null | grep -q -i "gamepad\\|joystick\\|SteelSeries\\|Logitech.*Game"; then
        echo -e "  ${GREEN}✓${NC} Gaming Peripherals: ${GREEN}Detected${NC}"
    else
        echo -e "  ${BLUE}ℹ${NC} Gaming Peripherals: ${BLUE}None detected${NC}"
    fi
    # 🎯 Gaming Mission: "Verificer spil-økosystemets konfiguration og tilgængelighed"
}

# -----------------------------------------------------------------------------
# POWER MANAGEMENT ADVANCED - STRØM OPTIMERING
# -----------------------------------------------------------------------------
#
check_advanced_power() {
    echo -e "${CYAN}Advanced Power Management:${NC}"

    # Check battery health if on laptop
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        local capacity
        capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
        local status
        status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")

        echo -e "  ${CYAN}-${NC} Battery: $capacity% ($status)"

        # Battery health warning
        if [ "$capacity" -lt 20 ] && [ "$status" = "Discharging" ]; then
            echo -e "  ${RED}!${NC} Battery: ${RED}Low - $capacity% remaining${NC}"
        fi
    else
        echo -e "  ${BLUE}ℹ${NC} Battery: ${BLUE}No battery (desktop system)${NC}"
    fi

    # Check TLP detailed status
    if command_exists tlp-stat; then
        local tlp_mode
        tlp_mode=$(tlp-stat -s 2>/dev/null | grep "Mode" | cut -d= -f2 | xargs || echo "Unknown")
        echo -e "  ${CYAN}-${NC} TLP Mode: $tlp_mode"
    fi

    # Check for power drain issues
    if [ -f "/proc/power/avg" ]; then
        local power_usage
        power_usage=$(cat /proc/power/avg 2>/dev/null || echo "Unknown")
        echo -e "  ${CYAN}-${NC} Power Usage: $power_usage mW"
    fi
    # 🎯 Power Mission: "Overvåg strømforbrug og batterioptimering"
}

# =============================================================================
# INITIAL SYSTEM VALIDATION - MILJØ VERIFIKATION
# =============================================================================
#
# 🛡️ ENVIRONMENT CHECKS:
# "Verificer at scriptet kører under korrekte betingelser"

# Validate NixOS environment
if [ ! -f "/etc/NIXOS" ]; then
    echo -e "${RED}Error: This script is designed for NixOS systems only.${NC}"
    exit 1
fi

# Root execution awareness
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}Warning: Running as root, some user services may not be detectable.${NC}"
fi

# -----------------------------------------------------------------------------
# LOGGING INFRASTRUCTURE - DIAGNOSTIK DATA PERSISTENCE
# -----------------------------------------------------------------------------
#
LOG_FILE=""
if [ "${1:-}" = "--log" ] && [ -n "${2:-}" ]; then
    LOG_FILE="$2"
    exec > >(tee -a "$LOG_FILE") 2>&1
    # 📝 Logging Strategy: "Bevar diagnostik historie for trend analyse"
fi

# =============================================================================
# SYSTEM IDENTIFICATION HEADER - MASKINENS FINGERAFFRYK
# =============================================================================
#
echo "================================================================"
echo "                   NIXOS SYSTEM HEALTH CHECK"
echo "================================================================"
echo "System: $(nixos-version 2>/dev/null || echo "Unknown")"
echo "Kernel: $(uname -r)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Hostname: $(hostname)"

# Fix uptime command for different versions
if uptime -p >/dev/null 2>&1; then
    echo "Uptime: $(uptime -p | sed 's/up //')"
else
    # Fallback for systems without -p flag
    echo "Uptime: $(uptime | sed 's/.*up //' | sed 's/,.*//')"
fi
echo "================================================================"

# =============================================================================
# SEKTION 1: NIXOS SPECIFIC DIAGNOSTICS - SYSTEMETS UNIKKE IDENTITET
# =============================================================================
#
print_header "NIXOS SPECIFIC DIAGNOSTICS"

# -----------------------------------------------------------------------------
# SYSTEM GENERATION ANALYSIS - NIXOS TILSTAND SHOTS
# -----------------------------------------------------------------------------
#
if command_exists nixos-rebuild; then
    current_gen=$(nixos-rebuild list-generations 2>/dev/null | grep "current" | head -1 | awk '{print $1, $2, $3, $4, $5}')
    if [ -n "$current_gen" ]; then
        echo -e "${GREEN}✓${NC} Current Generation: ${GREEN}$current_gen${NC}"
    else
        current_gen=$(nixos-rebuild list-generations 2>/dev/null | tail -1 | awk '{print $1, $2, $3, $4, $5}')
        echo -e "${BLUE}ℹ${NC} Current Generation: ${BLUE}$current_gen${NC}"
    fi
    # 🎯 Generation Tracking: "Forstå systemets evolution og rollback muligheder"
fi

# -----------------------------------------------------------------------------
# FLAKE CONFIGURATION VALIDATION - MODERNE SYSTEM MANAGEMENT
# -----------------------------------------------------------------------------
#
if [ -f "/etc/NIXOS" ] && [ -f "/etc/os-release" ]; then
    if [ -f "/etc/nixos/flake.nix" ]; then
        echo -e "${GREEN}✓${NC} System: ${GREEN}Flake-based configuration${NC}"
    else
        echo -e "${BLUE}ℹ${NC} System: ${BLUE}Traditional configuration${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# NIX CHANNEL ECOSYSTEM - PAKKE DISTRIBUTIONS NETVÆRK
# -----------------------------------------------------------------------------
#
if command_exists nix-channel; then
    channel_list=$(nix-channel --list 2>/dev/null)
    if [ -n "$channel_list" ]; then
        echo -e "${GREEN}✓${NC} Nix Channels: ${GREEN}Configured${NC}"
        echo -e "${CYAN}Channel Details:${NC}"
        echo "$channel_list" | while read -r channel; do
            echo -e "  ${CYAN}-${NC} $channel"
        done
    else
        echo -e "${YELLOW}?${NC} Nix Channels: ${YELLOW}None configured${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# NIX PAKKE MANAGER VERSION - KERNEL AF ØKOSYSTEMET
# -----------------------------------------------------------------------------
#
if command_exists nix; then
    nix_version=$(nix --version | head -1)
    echo -e "${GREEN}✓${NC} $nix_version"
fi

# =============================================================================
# SEKTION 2: DISPLAY & GRAPHICS DIAGNOSTICS - SYSTEMETS ØJNE
# =============================================================================
#
print_header "DISPLAY & GRAPHICS DIAGNOSTICS"

# -----------------------------------------------------------------------------
# DISPLAY MANAGER VERIFICATION - GRAFISK ADGANGSKONTROL
# -----------------------------------------------------------------------------
#
check_service "display-manager" "Display Manager"
check_service "sddm" "SDDM Display Manager"

# -----------------------------------------------------------------------------
# DISPLAY SERVER ANALYSIS - GRAFISK PROTOKOLLER
# -----------------------------------------------------------------------------
#
if pgrep -x "Xorg" > /dev/null; then
    echo -e "${GREEN}✓${NC} X11 Server: ${GREEN}Running${NC}"
    if [ -n "$DISPLAY" ]; then
        echo -e "${BLUE}ℹ${NC} X11 Display: ${BLUE}$DISPLAY${NC}"
    fi
elif pgrep -x "wayland" > /dev/null || pgrep -f "wayland" > /dev/null; then
    echo -e "${GREEN}✓${NC} Wayland: ${GREEN}Running${NC}"
else
    echo -e "${RED}✗${NC} Display Server: ${RED}Not running${NC}"
fi

# -----------------------------------------------------------------------------
# DESKTOP ENVIRONMENT VALIDATION - BRUGERENS ARBEJDSRUM
# -----------------------------------------------------------------------------
#
if pgrep -x "plasmashell" > /dev/null; then
    echo -e "${GREEN}✓${NC} KDE Plasma: ${GREEN}Running${NC}"
    if command_exists kf5-config; then
        kde_version=$(kf5-config --version | grep "KDE Frameworks" | awk '{print $2}')
        echo -e "${BLUE}ℹ${NC} KDE Frameworks: ${BLUE}$kde_version${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} KDE Plasma: ${YELLOW}Not detected (may not be started)${NC}"
fi

# =============================================================================
# SEKTION 3: NVIDIA GRAPHICS DIAGNOSTICS - GRAFISK BEREGNINGS KRAFT
# =============================================================================
#
print_header "NVIDIA GRAPHICS DIAGNOSTICS"

# -----------------------------------------------------------------------------
# HYBRID GRAPHICS ECOSYSTEM - DUAL GPU INTELLIGENS
# -----------------------------------------------------------------------------
#
check_nvidia_hybrid

# -----------------------------------------------------------------------------
# NVIDIA KERNEL MODULE ANALYSIS - GRAFISK DRIVER FUNDAMENT
# -----------------------------------------------------------------------------
#
nvidia_modules=$(lsmod | grep -c nvidia || true)
if [ "$nvidia_modules" -ge 4 ]; then
    echo -e "${GREEN}✓${NC} NVIDIA Modules: ${GREEN}$nvidia_modules loaded${NC}"
elif [ "$nvidia_modules" -gt 0 ]; then
    echo -e "${YELLOW}?${NC} NVIDIA Modules: ${YELLOW}$nvidia_modules loaded (partial)${NC}"
else
    echo -e "${RED}✗${NC} NVIDIA Modules: ${RED}None loaded${NC}"
fi

# -----------------------------------------------------------------------------
# NVIDIA HARDWARE TELEMETRY - GPU VITALTEGN
# -----------------------------------------------------------------------------
#
if command_exists nvidia-smi; then
    nvidia_driver=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1 || echo "Unknown")
    gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1 || echo "Unknown")
    gpu_count=$(nvidia-smi --query-gpu=count --format=csv,noheader 2>/dev/null | head -1 || echo "0")

    echo -e "${GREEN}✓${NC} NVIDIA Driver: ${GREEN}$nvidia_driver${NC}"
    echo -e "${GREEN}✓${NC} GPU: ${GREEN}$gpu_name${NC}"
    echo -e "${BLUE}ℹ${NC} GPU Count: ${BLUE}$gpu_count${NC}"

    # Real-time GPU Performance Metrics
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

# -----------------------------------------------------------------------------
# NVIDIA PRIME INTEGRATION - HYBRID GPU ORKESTERING
# -----------------------------------------------------------------------------
#
if command_exists prime-run; then
    echo -e "${GREEN}✓${NC} NVIDIA PRIME: ${GREEN}Available${NC}"
else
    echo -e "${YELLOW}?${NC} NVIDIA PRIME: ${YELLOW}Not detected${NC}"
fi

# =============================================================================
# SEKTION 4: AUDIO SYSTEM DIAGNOSTICS - LYDESKABT ATMOSFÆRE
# =============================================================================
#
print_header "AUDIO SYSTEM DIAGNOSTICS"

# -----------------------------------------------------------------------------
# PIPEWIRE AUDIO STACK - MODERN LYD ARKITEKTUR
# -----------------------------------------------------------------------------
#
check_user_service "pipewire" "PipeWire Audio"
check_user_service "pipewire-pulse" "PipeWire PulseAudio"
check_user_service "wireplumber" "WirePlumber Session Manager"

# -----------------------------------------------------------------------------
# AUDIO HARDWARE INVENTORY - LYD ENHEDS KARTOTEK
# -----------------------------------------------------------------------------
#
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
# SEKTION 5: NETWORKING DIAGNOSTICS - SYSTEMETS NERVESYSTEM
# =============================================================================
#
print_header "NETWORKING DIAGNOSTICS"

# -----------------------------------------------------------------------------
# NETWORK MANAGER VERIFICATION - INTELLIGENT NETVÆRKSSTYRING
# -----------------------------------------------------------------------------
#
check_service "NetworkManager" "NetworkManager"

# -----------------------------------------------------------------------------
# INTERNET CONNECTIVITY VALIDATION - GLOBAL FORBINDELSESKRAFT
# -----------------------------------------------------------------------------
#
if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Internet: ${GREEN}Connected${NC}"

    # Optional public IP detection
    if command_exists curl; then
        public_ip=$(curl -s --connect-timeout 5 https://ipinfo.io/ip || echo "Unknown")
        echo -e "${BLUE}ℹ${NC} Public IP: ${BLUE}$public_ip${NC}"
    fi
else
    echo -e "${RED}✗${NC} Internet: ${RED}No connection${NC}"
fi

# -----------------------------------------------------------------------------
# NETWORK INTERFACE INVENTORY - NETVÆRKS ENHEDS KARTOTEK
# -----------------------------------------------------------------------------
#
echo -e "${CYAN}Network Interfaces:${NC}"
ip -o addr show | awk '{print $2, $4}' | while read -r interface ip; do
    if [ "$interface" != "lo" ]; then
        echo -e "  ${CYAN}-${NC} $interface: $ip"
    fi
done

# -----------------------------------------------------------------------------
# WIRELESS ECOSYSTEM - TRÅDLØS KOMMUNIKATION
# -----------------------------------------------------------------------------
#
check_service "bluetooth" "Bluetooth Service"
if command_exists rfkill; then
    rfkill_list=$(rfkill list)
    echo -e "${CYAN}RFKill Status:${NC}"
    echo "$rfkill_list" | while read -r line; do
        echo -e "  ${CYAN}-${NC} $line"
    done
fi

# =============================================================================
# SEKTION 6: SYSTEM SERVICES DIAGNOSTICS - VITALE FUNKTIONER
# =============================================================================
#
print_header "SYSTEM SERVICES DIAGNOSTICS"

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
# SEKTION 7: SYSTEM RESOURCE DIAGNOSTICS - MASKINENS KROP
# =============================================================================
#
print_header "SYSTEM RESOURCE DIAGNOSTICS"

# -----------------------------------------------------------------------------
# STORAGE CAPACITY ANALYSIS - DATA PLADS INVENTORY
# -----------------------------------------------------------------------------
#
echo -e "${CYAN}Disk Usage:${NC}"
df -h / | awk 'NR==2 {printf "  ✓ Root: %s/%s (%s used)\n", $4, $2, $5}'
df -h /home 2>/dev/null | awk 'NR==2 {printf "  ✓ Home: %s/%s (%s used)\n", $4, $2, $5}' || true
df -h /nix 2>/dev/null | awk 'NR==2 {printf "  ✓ Nix: %s/%s (%s used)\n", $4, $2, $5}' || true

# -----------------------------------------------------------------------------
# MEMORY UTILIZATION METRICS - HUKOMMELSES EFFEKTIVITET
# -----------------------------------------------------------------------------
#
echo -e "${CYAN}Memory Usage:${NC}"
free -h | awk 'NR==2 {printf "  ✓ RAM: %s/%s used (%.0f%%)\n", $3, $2, $3/$2 * 100}'
free -h | awk 'NR==3 {printf "  ✓ Swap: %s/%s used\n", $3, $2}'

# -----------------------------------------------------------------------------
# PROCESSOR PERFORMANCE ANALYSIS - CPU VITALTEGN
# -----------------------------------------------------------------------------
#
cpu_cores=$(nproc)
cpu_load=$(uptime | sed 's/.*load average: //' | cut -d, -f1 | tr -d ' ')
cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
echo -e "${CYAN}CPU Analysis:${NC}"
echo -e "  ${CYAN}-${NC} Model: $cpu_model"
echo -e "  ${CYAN}-${NC} Cores: $cpu_cores"
echo -e "  ${CYAN}-${NC} Load: $cpu_load"

# -----------------------------------------------------------------------------
# THERMAL MANAGEMENT MONITORING - VARMESTYRS SYSTEM
# -----------------------------------------------------------------------------
#
if command_exists sensors; then
    echo -e "${CYAN}Thermal Status:${NC}"
    sensors | grep -E "Package id|Core|temp1" | head -3 | while read -r line; do
        echo -e "  ${CYAN}-${NC} $line"
    done
fi

# =============================================================================
# SEKTION 8: DEVELOPMENT ECOSYSTEM DIAGNOSTICS - UDVIKLER VÆRKTØJER
# =============================================================================
#
print_header "DEVELOPMENT ECOSYSTEM DIAGNOSTICS"

# -----------------------------------------------------------------------------
# FLATPAK CONTAINER PLATFORM - SANDBOXED APPLICATION RUNTIME
# -----------------------------------------------------------------------------
#
if command_exists flatpak; then
    flatpak_count=$(flatpak list --app 2>/dev/null | wc -l || echo "0")
    echo -e "${GREEN}✓${NC} Flatpak: ${GREEN}$flatpak_count applications${NC}"
else
    echo -e "${YELLOW}?${NC} Flatpak: ${YELLOW}Not available${NC}"
fi

# -----------------------------------------------------------------------------
# NIX DEVELOPMENT TOOLCHAIN - PAKKE MANAGER VÆRKTØJER
# -----------------------------------------------------------------------------
#
nix_tools=("nix-shell" "home-manager" "nixops" "nix-index" "nix-search")
for tool in "${nix_tools[@]}"; do
    if command_exists "$tool"; then
        echo -e "${GREEN}✓${NC} $tool: ${GREEN}Available${NC}"
    else
        echo -e "${BLUE}ℹ${NC} $tool: ${BLUE}Not installed${NC}"
    fi
done

# -----------------------------------------------------------------------------
# CONTAINERIZATION PLATFORMS - APPLICATION ISOLATION TEKNOLOGIER
# -----------------------------------------------------------------------------
#
if command_exists docker; then
    docker_version=$(docker --version | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} Docker: ${GREEN}$docker_version${NC}"
else
    echo -e "${RED}✗${NC} Docker: ${RED}Not available${NC}"
fi

if command_exists podman; then
    podman_version=$(podman --version | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} Podman: ${GREEN}$podman_version${NC}"
else
    echo -e "${YELLOW}?${NC} Podman: ${YELLOW}Not available${NC}"
fi

# -----------------------------------------------------------------------------
# PROGRAMMING LANGUAGE RUNTIMES - UDVIKLINGSMILJØER
# -----------------------------------------------------------------------------
#
if command_exists python3; then
    python_version=$(python3 --version | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} Python: ${GREEN}$python_version${NC}"
fi

if command_exists node; then
    node_version=$(node --version)
    echo -e "${GREEN}✓${NC} Node.js: ${GREEN}$node_version${NC}"
fi

if command_exists go; then
    go_version=$(go version | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} Go: ${GREEN}$go_version${NC}"
fi

if command_exists rustc; then
    # Better rustc version detection
    rust_version=$(rustc --version 2>/dev/null | head -1 | cut -d' ' -f2 || echo "Unknown")
    if [ "$rust_version" = "Unknown" ]; then
        echo -e "${YELLOW}?${NC} Rust: ${YELLOW}Installed but no default toolchain${NC}"
    else
        echo -e "${GREEN}✓${NC} Rust: ${GREEN}$rust_version${NC}"
    fi
else
    echo -e "${BLUE}ℹ${NC} Rust: ${BLUE}Not available${NC}"
fi

# =============================================================================
# SEKTION 9: USER ENVIRONMENT DIAGNOSTICS - BRUGERENS VERDEN
# =============================================================================
#
print_header "USER ENVIRONMENT DIAGNOSTICS"

# -----------------------------------------------------------------------------
# SHELL ENVIRONMENT ANALYSIS - KOMMANDO MILJØ VALIDATION
# -----------------------------------------------------------------------------
#
current_shell=$(basename "$SHELL")
echo -e "${CYAN}Shell Environment:${NC} $current_shell"

case $current_shell in
    "zsh")
        zsh_version=$(zsh --version 2>/dev/null | head -1 || echo "Unknown")
        echo -e "  ${CYAN}-${NC} Version: $zsh_version"
        ;;
    "bash")
        bash_version=$(bash --version 2>/dev/null | head -1 || echo "Unknown")
        echo -e "  ${CYAN}-${NC} Version: $bash_version"
        ;;
    "fish")
        fish_version=$(fish --version 2>/dev/null | head -1 || echo "Unknown")
        echo -e "  ${CYAN}-${NC} Version: $fish_version"
        ;;
esac

# -----------------------------------------------------------------------------
# DESKTOP ENVIRONMENT VARIABLES - GRAFISK MILJØ KONFIGURATION
# -----------------------------------------------------------------------------
#
echo -e "${CYAN}Desktop Environment:${NC}"
echo -e "  ${CYAN}-${NC} QT Platform: ${QT_QPA_PLATFORM:-Not set}"
echo -e "  ${CYAN}-${NC} Desktop: ${XDG_CURRENT_DESKTOP:-Not set}"
echo -e "  ${CYAN}-${NC} Session: ${XDG_SESSION_TYPE:-Not set}"

# -----------------------------------------------------------------------------
# USER PRIVILEGE VALIDATION - SYSTEM ADGANGSRETTIGHEDER
# -----------------------------------------------------------------------------
#
if groups | grep -q wheel; then
    echo -e "${GREEN}✓${NC} User Groups: ${GREEN}Wheel group access OK${NC}"
else
    echo -e "${RED}✗${NC} User Groups: ${RED}No wheel group access${NC}"
fi

# =============================================================================
# SEKTION 10: GRAPHICS & PERFORMANCE DIAGNOSTICS - VISUEL YDEEVNE
# =============================================================================
#
print_header "GRAPHICS & PERFORMANCE DIAGNOSTICS"

# -----------------------------------------------------------------------------
# OPENGL RENDERING VALIDATION - 3D GRAFIK STACK
# -----------------------------------------------------------------------------
#
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

# -----------------------------------------------------------------------------
# VULKAN API VALIDATION - MODERNE GRAFIK STANDARD
# -----------------------------------------------------------------------------
#
if command_exists vulkaninfo; then
    vulkan_version=$(vulkaninfo --summary 2>/dev/null | head -20 | grep "Vulkan API" | head -1 | cut -d: -f2 | xargs || echo "Unknown")
    if [ "$vulkan_version" != "Unknown" ]; then
        echo -e "${GREEN}✓${NC} Vulkan: $vulkan_version"
    else
        echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}Available but no version info${NC}"
    fi
else
    echo -e "${YELLOW}?${NC} Vulkan: ${YELLOW}vulkaninfo not available${NC}"
fi

# =============================================================================
# SEKTION 11: SECURITY & PERFORMANCE DIAGNOSTICS - SYSTEMETS FORSVAR
# =============================================================================
#
print_header "SECURITY & PERFORMANCE DIAGNOSTICS"

# -----------------------------------------------------------------------------
# FIREWALL PROTECTION VALIDATION - NETVÆRKS SIKKERHED
# -----------------------------------------------------------------------------
#
if systemctl is-active firewalld >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (firewalld)${NC}"
elif systemctl is-active ufw >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (ufw)${NC}"
elif iptables -L 2>/dev/null | grep -q -E "(Chain INPUT|Chain FORWARD|Chain OUTPUT)" && ! iptables -L 2>/dev/null | grep -q "Chain INPUT (policy ACCEPT)"; then
    echo -e "${GREEN}✓${NC} Firewall: ${GREEN}Active (iptables)${NC}"
else
    echo -e "${YELLOW}!${NC} Firewall: ${YELLOW}No active rules detected${NC}"
fi

# -----------------------------------------------------------------------------
# SWAP MEMORY MANAGEMENT - VIRTUELL HUKOMMELSES RESERVE
# -----------------------------------------------------------------------------
#
if swapon --show 2>/dev/null | grep -q .; then
    swap_usage=$(free -h | awk 'NR==3 {print $3 "/" $2 " (" $3/$2 * 100 "%)"}')
    echo -e "${GREEN}✓${NC} Swap: ${GREEN}$swap_usage used${NC}"
else
    echo -e "${BLUE}ℹ${NC} Swap: ${BLUE}Not active${NC}"
fi

# -----------------------------------------------------------------------------
# SYSTEM UPDATE AVAILABILITY - PAKKE OPdaterings STATUS
# -----------------------------------------------------------------------------
#
if command_exists nixos-rebuild; then
    echo -e "${BLUE}ℹ${NC} System Updates: ${BLUE}Check with 'sudo nixos-rebuild dry-activate'${NC}"
fi

# =============================================================================
# SEKTION 12: APPLICATION ECOSYSTEM DIAGNOSTICS - SOFTWARE ØKOSYSTEM
# =============================================================================
#
print_header "APPLICATION ECOSYSTEM DIAGNOSTICS"

# -----------------------------------------------------------------------------
# CORE APPLICATION AVAILABILITY - ESSENTIEL SOFTWARE
# -----------------------------------------------------------------------------
#
apps=("firefox" "dolphin" "kate" "konsole" "chromium" "okular" "gimp" "vlc" "code" "spotify" "discord")
for app in "${apps[@]}"; do
    if command_exists "$app"; then
        echo -e "${GREEN}✓${NC} $app: ${GREEN}Available${NC}"
    else
        echo -e "${BLUE}ℹ${NC} $app: ${BLUE}Not available${NC}"
    fi
done

# =============================================================================
# SEKTION 13: ADVANCED NIXOS DIAGNOSTICS - SYSTEMETS DYBDEDIAGNOSTIK
# =============================================================================
#
print_header "ADVANCED NIXOS DIAGNOSTICS"

check_nix_store
check_nix_gc

# =============================================================================
# SEKTION 14: SECURITY & HARDENING AUDIT - SYSTEMETS FORSVARSVÆRN
# =============================================================================
#
print_header "SECURITY & HARDENING AUDIT"

check_security_hardening

# =============================================================================
# SEKTION 15: PERFORMANCE & BENCHMARKING - MASKINENS YDEEVNE
# =============================================================================
#
print_header "PERFORMANCE & BENCHMARKING"

check_storage_performance
check_memory_performance
check_network_performance

# =============================================================================
# SEKTION 16: CONTAINER & VIRTUALIZATION HEALTH - VIRTUALISERINGSFUNDAMENT
# =============================================================================
#
print_header "CONTAINER & VIRTUALIZATION HEALTH"

check_docker_health
check_virtualization

# =============================================================================
# SEKTION 17: DESKTOP & GAMING ECOSYSTEM - BRUGEROPLEVELSE
# =============================================================================
#
print_header "DESKTOP & GAMING ECOSYSTEM"

check_kde_health
check_gaming_ecosystem
check_advanced_power

# =============================================================================
# SEKTION 18: SYSTEM HEALTH ASSESSMENT - HELBREDSVURDERING
# =============================================================================
#
print_header "SYSTEM HEALTH ASSESSMENT"

# -----------------------------------------------------------------------------
# SYSTEM JOURNAL ERROR ANALYSIS - LOG BASERET FEJLDETEKTION
# -----------------------------------------------------------------------------
#
check_journal_errors

# -----------------------------------------------------------------------------
# X11 ERROR DETECTION - GRAFISK SYSTEM FEJL
# -----------------------------------------------------------------------------
#
if [ -f "/var/log/Xorg.0.log" ]; then
    xerrors=$(grep -c "(EE)" /var/log/Xorg.0.log 2>/dev/null || echo "0")
    if [ "$xerrors" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} X11 Logs: ${GREEN}No errors found${NC}"
    else
        echo -e "${YELLOW}!${NC} X11 Logs: ${YELLOW}$xerrors errors found${NC}"
    fi
fi

# -----------------------------------------------------------------------------
# SYSTEMD SERVICE FAILURE ANALYSIS - TJENESTE FEJL DETEKTION
# -----------------------------------------------------------------------------
#
failed_services_count=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [ "$failed_services_count" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Systemd Services: ${GREEN}No failed services${NC}"
else
    echo -e "${RED}!${NC} Systemd Services: ${RED}$failed_services_count failed services${NC}"
    systemctl --failed --no-legend 2>/dev/null | while read -r service; do
        echo -e "  ${RED}-${NC} $service"
    done
fi

# -----------------------------------------------------------------------------
# USER SERVICE FAILURE ANALYSIS - BRUGER TJENESTE FEJL
# -----------------------------------------------------------------------------
#
if [ "$EUID" -ne 0 ]; then
    failed_user_services_count=$(systemctl --user --failed --no-legend 2>/dev/null | wc -l)
    if [ "$failed_user_services_count" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} User Services: ${GREEN}No failed services${NC}"
    else
        echo -e "${RED}!${NC} User Services: ${RED}$failed_user_services_count failed services${NC}"
    fi
fi

# =============================================================================
# DIAGNOSTIC COMPLETION - SYSTEMETS HELBREDSCERTIFIKAT
# =============================================================================
#
echo
echo "================================================================"
echo -e "${GREEN}SYSTEM HEALTH CHECK COMPLETE${NC}"
echo "================================================================"
echo "For detailed investigation:"
echo "  System errors: journalctl -p 3 -xb"
echo "  X11 logs: cat /var/log/Xorg.0.log | grep -i error"
echo "  Service status: systemctl status <service-name>"
echo "  Failed services: systemctl --failed"
if [ -n "$LOG_FILE" ]; then
    echo "  Diagnostic log: $LOG_FILE"
fi
echo "================================================================"

# -----------------------------------------------------------------------------
# EXIT CODE STRATEGY - DIAGNOSTIK RESULTAT INTERPRETATION
# -----------------------------------------------------------------------------
#
if [ "$failed_services_count" -gt 0 ] || [ "$JOURNAL_ERRORS" -gt 0 ]; then
    exit 1
else
    exit 0
fi

# =============================================================================
# SCRIPT LIVSCYKLUS - DIAGNOSTIK PROCESSENS REJSE
# =============================================================================
#
# 🚀 EXECUTION WORKFLOW:
# $ ./nixos-health-check.sh [--log /path/to/logfile]
#   ├── Environment Validation: Verificer NixOS og privilegier
#   ├── System Identification: Indsaml maskine fingerprint
#   ├── Component Diagnostics: Kør 18 specialiserede diagnostik sektioner
#   ├── Health Assessment: Aggreger resultater til helhedsvurdering
#   └── Exit Code: Returner success/fejl baseret på systemtilstand
#
# 🎯 DIAGNOSTIC COVERAGE:
# - NixOS Specific: Flakes, generations, channels, store integrity, GC status
# - Graphics: NVIDIA hybrid, OpenGL, Vulkan, PRIME, rendering performance
# - Audio: PipeWire stack, hardware detection, session management
# - Networking: Connectivity, interfaces, wireless, performance, DNS
# - Services: Systemd, Docker, virtualization, power management, security
# - Resources: Storage, memory, CPU, thermal, performance metrics
# - Development: Toolchains, containers, languages, package management
# - Security: Firewall, user privileges, hardening, SSH monitoring
# - Applications: Core software availability, gaming ecosystem
# - Desktop: KDE Plasma session, compositor, crash monitoring
# - Power: Battery management, TLP optimization, power usage
#
# =============================================================================
# TAK FOR AT VALGE PROFESSIONEL SYSTEM DIAGNOSTIK! 🩺
# =============================================================================
