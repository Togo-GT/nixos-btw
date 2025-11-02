
#!/usr/bin/env bash
# NIXOS-BTW SIMPLE EDITION
DATE=$(date +"%Y-%m-%d")

echo -e "
\e[1m\e[96m        NIXOS-BTW
      Ultimate Edition\e[0m

\e[1m\e[92m▶ CORE FEATURES\e[0m
 \e[96m•\e[0m KDE Plasma 6 + Wayland
 \e[96m•\e[0m NVIDIA PRIME + GTX 960M
 \e[96m•\e[0m Wine + DXVK Gaming Suite
 \e[96m•\e[0m Steam + Lutris + MangoHUD
 \e[96m•\e[0m PipeWire Audio
 \e[96m•\e[0m Docker + Virtualization
 \e[96m•\e[0m Zsh + Dev Environment

\e[1m\e[94m▶ SYSTEM SPECS\e[0m
 \e[95m•\e[0m NVIDIA Driver: 580.95.05
 \e[95m•\e[0m Kernel: Linux latest
 \e[95m•\e[0m Desktop: KDE Plasma 6
 \e[95m•\e[0m Shell: Zsh + agnoster

\e[1m\e[93m▶ GAMING OPTIMIZATIONS\e[0m
 \e[91m•\e[0m Proton-GE enabled
 \e[91m•\e[0m DXVK Async enabled
 \e[91m•\e[0m Gamemode tuned
 \e[91m•\e[0m NVIDIA perf tweaks

\e[1m\e[96m──────────────────────────────\e[0m
Built: \e[93m$DATE\e[0m
\e[92m» \e[1m\"I use NixOS, btw\"\e[0m \e[92m«\e[0m
"

# System status - FIXED uptime command
echo -e "\e[1m\e[95m▶ LIVE STATUS:\e[0m"
nvidia_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits 2>/dev/null || echo "Active")
echo -e " \e[92m✓\e[0m NVIDIA: $nvidia_version"
echo -e " \e[92m✓\e[0m Kernel: $(uname -r)"
# Fixed uptime command for NixOS
uptime_output=$(uptime | awk -F'up' '{print $2}' | awk -F',' '{print $1}' | sed 's/^ *//')
echo -e " \e[92m✓\e[0m Uptime: $uptime_output"
