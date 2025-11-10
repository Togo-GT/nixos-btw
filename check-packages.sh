#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Package categories
declare -A categories=(
    [1]="CORE SYSTEM TOOLS"
    [2]="PACKAGE MANAGEMENT (NIX)"
    [3]="SHELL & TERMINAL"
    [4]="HARDWARE INFORMATION"
    [5]="POWER MANAGEMENT"
    [6]="STORAGE & FILESYSTEMS"
    [7]="GRAPHICS & GPU"
    [8]="AUDIO"
    [9]="DEVELOPMENT TOOLS"
    [10]="PROGRAMMING LANGUAGES"
    [11]="DEVELOPMENT UTILITIES"
    [12]="LANGUAGE SERVERS"
    [13]="CONTAINERS & VIRTUALIZATION"
    [14]="INFRASTRUCTURE & DEVOPS"
    [15]="NETWORK TOOLS"
    [16]="SECURITY"
    [17]="CLI PRODUCTIVITY"
    [18]="GIT TOOLS"
    [19]="FILE MANAGEMENT"
    [20]="MULTIMEDIA"
    [21]="GAMING"
    [22]="GUI APPLICATIONS"
    [23]="SYSTEM MONITORING"
    [24]="INFORMATION & DOCUMENTATION"
    [25]="QT6 PACKAGES"
    [26]="LOGITECH / GAMING MOUSE SUPPORT"
    [27]="THEMES & APPEARANCE"
    [28]="FUN & ENTERTAINMENT"
)

# Function to load packages from packages.nix
load_packages_from_nix() {
    local packages_nix_file="packages.nix"

    # Check if packages.nix exists
    if [[ ! -f "$packages_nix_file" ]]; then
        echo -e "${RED}Error: $packages_nix_file not found in current directory${NC}" >&2
        echo -e "${YELLOW}Please run this script from your nixos-config directory${NC}" >&2
        exit 1
    fi

    # Parse packages.nix and extract package names
    echo -e "${CYAN}Loading packages from $packages_nix_file...${NC}" >&2

    # Use awk to extract package names from the Nix file
    # This pattern matches lines with package names (handles both single and double quotes)
    awk '
    /^[[:space:]]*[#]/ { next }  # Skip comment lines
    /[a-zA-Z0-9_-]+/ {
        # Remove leading/trailing whitespace and commas
        gsub(/^[[:space:]]*|[[:space:]]*,$/, "")
        # Remove quotes
        gsub(/["]/, "")
        # Remove line comments
        gsub(/[[:space:]]*#.*$/, "")
        # Skip empty lines and lines that dont look like package names
        if ($0 ~ /^[a-zA-Z0-9_-]+$/) {
            print $0
        }
    }
    ' "$packages_nix_file"
}

# Function to categorize packages
categorize_packages() {
    declare -A categorized
    local package

    # Read packages from packages.nix
    while IFS= read -r package; do
        [[ -z "$package" ]] && continue

        # Categorize packages - ordered by specificity to avoid duplicates
        case $package in
            # PACKAGE MANAGEMENT (NIX) - specific Nix tools first
            home-manager|nix-index|nix-search|nixd|nix-tree|nix-diff|nix-output-monitor|nix-du|nixos-option|comma|nixpkgs-fmt|nixfmt-classic|statix|alejandra|manix|cachix|direnv|nixos-generators|nh|nil)
                categorized["PACKAGE MANAGEMENT (NIX)"]+="$package "
                ;;
            # LANGUAGE SERVERS - specific development tools
            nodePackages.bash-language-server|nodePackages.typescript-language-server|nodePackages.vscode-langservers-extracted|rust-analyzer|python3Packages.python-lsp-server|lua-language-server|marksman|clang-tools)
                categorized["LANGUAGE SERVERS"]+="$package "
                ;;
            # DEVELOPMENT TOOLS
            gcc|gnumake|pkg-config|cmake|gdb|strace|ltrace|valgrind|shellcheck|hadolint)
                categorized["DEVELOPMENT TOOLS"]+="$package "
                ;;
            # PROGRAMMING LANGUAGES
            python3|python3Packages.pip|pipx|go|nodejs|perl|rustup)
                categorized["PROGRAMMING LANGUAGES"]+="$package "
                ;;
            # DEVELOPMENT UTILITIES
            jq|yq|hexyl|hyperfine|tokei|binutils)
                categorized["DEVELOPMENT UTILITIES"]+="$package "
                ;;
            # SHELL & TERMINAL
            zoxide|starship|oh-my-posh|fish|zsh|tmux|tmuxp)
                categorized["SHELL & TERMINAL"]+="$package "
                ;;
            # CLI PRODUCTIVITY
            eza|bat|bat-extras.batdiff|bat-extras.batman|bat-extras.batpipe|fd|ripgrep|ripgrep-all|fzf|bottom|dust|procs|sd|choose|fselect|tree|broot|watch)
                categorized["CLI PRODUCTIVITY"]+="$package "
                ;;
            # GIT TOOLS
            git|gitFull|git-extras|delta|lazygit|github-cli|git-crypt|git-open|git-revise|gitui|gitflow|tig)
                categorized["GIT TOOLS"]+="$package "
                ;;
            # CONTAINERS & VIRTUALIZATION
            docker|docker-compose|podman|distrobox|virt-manager|virt-viewer|qemu|qemu_kvm|qemu-utils|quickemu|libvirt|spice|spice-gtk|spice-protocol|spice-vdagent|vde2|bridge-utils|dnsmasq|OVMF|virtualbox|vagrant|libguestfs|guestfs-tools|openvswitch|virt-top)
                categorized["CONTAINERS & VIRTUALIZATION"]+="$package "
                ;;
            # INFRASTRUCTURE & DEVOPS
            ansible|packer|terraform)
                categorized["INFRASTRUCTURE & DEVOPS"]+="$package "
                ;;
            # NETWORK TOOLS
            networkmanagerapplet|wireshark|nmap|masscan|iperf3|traceroute|mtr|ipcalc|iftop|bmon|netcat-openbsd|socat|tcpdump|tcpflow|httpie|sshpass|sshfs|whois|macchanger|openvpn|tailscale|wireguard-tools|inetutils|bind|openssh)
                categorized["NETWORK TOOLS"]+="$package "
                ;;
            # SECURITY
            age|sops|aircrack-ng|ettercap)
                categorized["SECURITY"]+="$package "
                ;;
            # GUI APPLICATIONS
            chromium|firefox|signal-desktop|telegram-desktop|thunderbird|spotify|kdePackages.okular|zathura|kdePackages.dolphin|evince|feh|kdePackages.konsole|paprefs|protonup-qt|transmission_4-qt|vscode|keepassxc)
                categorized["GUI APPLICATIONS"]+="$package "
                ;;
            # QT6 PACKAGES
            qt6.qtbase|qt6.qtdeclarative|qt6.qttools|qt6.qtwayland|qt6.qtmultimedia|qt6.qtsvg|qt6.qtwebengine)
                categorized["QT6 PACKAGES"]+="$package "
                ;;
            # GAMING
            steam|lutris|wine|wineWowPackages.stable|winetricks|protontricks|mangohud|goverlay|gamemode)
                categorized["GAMING"]+="$package "
                ;;
            # MULTIMEDIA
            ffmpeg|mpv|imagemagick|audacity|handbrake|vlc|gimp|inkscape|krita|obs-studio)
                categorized["MULTIMEDIA"]+="$package "
                ;;
            # AUDIO
            pulsemixer|pavucontrol|alsa-utils|easyeffects|carla|helvum|qjackctl|jack2)
                categorized["AUDIO"]+="$package "
                ;;
            # GRAPHICS & GPU
            nvidia-vaapi-driver|nvitop|vulkan-tools|vulkan-loader|mesa-demos|libva-utils|vdpauinfo|clinfo|glmark2|gpu-viewer|intel-gpu-tools|dxvk|vkd3d-proton|vkbasalt)
                categorized["GRAPHICS & GPU"]+="$package "
                ;;
            # SYSTEM MONITORING
            neofetch|onefetch|fastfetch|gotop|btop|htop|iotop|nethogs|bandwhich|zenith|dool|mission-center|glances|netdata)
                categorized["SYSTEM MONITORING"]+="$package "
                ;;
            # FILE MANAGEMENT
            ranger|nnn|fff|mc|lf)
                categorized["FILE MANAGEMENT"]+="$package "
                ;;
            # STORAGE & FILESYSTEMS
            gnome-disk-utility|gparted|ncdu|duf|agedu|rsync|btrfs-progs|xfsprogs|e2fsprogs|mdadm|lvm2|cryptsetup|nvme-cli|util-linux|testdisk|gsmartcontrol|ntfs3g|borgbackup|rsnapshot)
                categorized["STORAGE & FILESYSTEMS"]+="$package "
                ;;
            # POWER MANAGEMENT
            powertop|acpi|cpupower-gui|powerstat|smartmontools|s-tui|stress-ng)
                categorized["POWER MANAGEMENT"]+="$package "
                ;;
            # HARDWARE INFORMATION
            pciutils|usbutils|lm_sensors|inxi|dmidecode|lshw)
                categorized["HARDWARE INFORMATION"]+="$package "
                ;;
            # CORE SYSTEM TOOLS - catch-all for basic system tools
            vim|neovim|micro|wget|curl|curlie|file|libnotify|psmisc|p7zip|unzip|zip|openssl|efibootmgr)
                categorized["CORE SYSTEM TOOLS"]+="$package "
                ;;
            # INFORMATION & DOCUMENTATION
            tldr|cheat|taskwarrior3)
                categorized["INFORMATION & DOCUMENTATION"]+="$package "
                ;;
            # LOGITECH / GAMING MOUSE SUPPORT
            libratbag|piper)
                categorized["LOGITECH / GAMING MOUSE SUPPORT"]+="$package "
                ;;
            # THEMES & APPEARANCE
            catppuccin-kde|catppuccin-gtk|tela-circle-icon-theme|papirus-icon-theme)
                categorized["THEMES & APPEARANCE"]+="$package "
                ;;
            # FUN & ENTERTAINMENT
            cowsay|fortune|sl|asciiquarium|cbonsai|cmatrix|figlet|speedtest-cli|fast-cli|termscp|cava|pipes-rs|lolcat)
                categorized["FUN & ENTERTAINMENT"]+="$package "
                ;;
            # UNCATEGORIZED - add to misc category
            *)
                categorized["UNCATEGORIZED"]+="$package "
                ;;
        esac
    done < <(load_packages_from_nix)

    # Return the categorized array
    for category in "${!categorized[@]}"; do
        echo "$category|${categorized[$category]}"
    done
}

# Initialize packages array from packages.nix
declare -A packages
echo -e "${CYAN}Initializing packages from packages.nix...${NC}"
while IFS='|' read -r category package_list; do
    packages["$category"]="$package_list"
done < <(categorize_packages)

# Function to map package names to their actual binaries
get_package_binary() {
    local package=$1
    local binary_name

    case $package in
        neovim) binary_name="nvim" ;;
        pciutils) binary_name="lspci" ;;
        usbutils) binary_name="lsusb" ;;
        lm_sensors) binary_name="sensors" ;;
        psmisc) binary_name="killall" ;;
        p7zip) binary_name="7z" ;;
        libnotify) binary_name="notify-send" ;;
        python3Packages.pip) binary_name="pip" ;;
        wineWowPackages.stable) binary_name="wine" ;;
        bat-extras.batdiff) binary_name="batdiff" ;;
        bat-extras.batman) binary_name="batman" ;;
        bat-extras.batpipe) binary_name="batpipe" ;;
        nodePackages.bash-language-server) binary_name="bash-language-server" ;;
        nodePackages.typescript-language-server) binary_name="typescript-language-server" ;;
        nodePackages.vscode-langservers-extracted) binary_name="vscode-langservers-extracted" ;;
        python3Packages.python-lsp-server) binary_name="pylsp" ;;

        # Fixed mappings for Nix packages
        nix-output-monitor) binary_name="nom" ;;
        nixfmt-classic) binary_name="nixfmt" ;;
        nix-search) binary_name="nix-search" ;;
        nix-diff) binary_name="nix-diff" ;;
        nixos-option) binary_name="nixos-option" ;;
        nixpkgs-fmt) binary_name="nixpkgs-fmt" ;;
        nixos-generators) binary_name="nixos-generate" ;;

        qt6.*|kdePackages.*) binary_name="" ;; # Libraries, no binaries
        *) binary_name="$package" ;;
    esac

    echo "$binary_name"
}

# Function to check if a package is installed
check_package() {
    local package=$1
    local binary_name
    binary_name=$(get_package_binary "$package")

    # First, check if binary exists in system paths (most reliable)
    if [[ -n "$binary_name" ]] && command -v "$binary_name" &> /dev/null; then
        return 0
    fi

    # Check if package exists in nix store with multiple name patterns
    if nix-locate --installed "$package" &> /dev/null || \
       nix-locate --installed "nixos.$package" &> /dev/null || \
       nix-locate --installed "legacyPackages.x86_64-linux.$package" &> /dev/null || \
       nix-store -q --references /run/current-system/sw | grep -q "$package"; then
        return 0
    else
        return 1
    fi
}

# Function to get package version
get_package_version() {
    local package=$1
    local binary_name
    local version
    binary_name=$(get_package_binary "$package")

    # If no binary (library package), just return installed
    if [[ -z "$binary_name" ]]; then
        echo "installed"
        return
    fi

    version=""

    case $binary_name in
        vim|nvim|micro|wget|curl|curlie|file|inxi|efibootmgr|dmidecode|lshw|lsof|unzip|zip|openssl|sensors|killall|7z|notify-send)
            version=$("$binary_name" --version 2>/dev/null | head -n 1)
            ;;
        lspci|lsusb)
            version=$("$binary_name" -v 2>/dev/null | head -n 1)
            ;;
        python3|node|go|perl|rustc|gcc|make|cmake|gdb|docker|podman|ansible|terraform|git|nom|nixfmt|nixpkgs-fmt|statix|alejandra|manix|cachix|direnv|nh|nil|nix-search|nix-diff|nixos-generate|nixos-option)
            version=$("$binary_name" --version 2>/dev/null | head -n 1)
            ;;
        pip)
            version=$("$binary_name" --version 2>/dev/null)
            ;;
        *)
            # Try to get version with --version flag
            if command -v "$binary_name" &>/dev/null && "$binary_name" --version &>/dev/null 2>&1; then
                version=$("$binary_name" --version 2>/dev/null | head -n 1)
            fi
            ;;
    esac

    # Clean up version string
    if [[ -n "$version" ]]; then
        echo "$version" | sed 's/^[^0-9]*//' | head -c 50
    else
        echo "installed"
    fi
}

# Function to check all packages in a category
check_category() {
    local category_name=$1
    local package_list
    local missing_packages=()
    local package
    local version
    local binary_name

    package_list=${packages[$category_name]}

    # Skip if category has no packages
    if [[ -z "$package_list" ]]; then
        echo -e "${YELLOW}No packages found in $category_name${NC}"
        echo
        read -r -p "Press Enter to continue..."
        return
    fi

    echo -e "${CYAN}=== Checking $category_name ===${NC}"
    echo

    for package in $package_list; do
        if check_package "$package"; then
            version=$(get_package_version "$package")
            binary_name=$(get_package_binary "$package")

            if [[ -n "$binary_name" ]]; then
                if [[ "$version" != "installed" ]]; then
                    echo -e "${GREEN}✓ $package${NC}"
                    echo -e "  Version: $version"
                else
                    echo -e "${GREEN}✓ $package = ok${NC}"
                fi
            else
                echo -e "${GREEN}✓ $package (library) = installed${NC}"
            fi
        else
            echo -e "${RED}✗ $package = no${NC}"
            missing_packages+=("$package")
        fi
        echo
    done

    # Handle missing packages
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo -e "${YELLOW}Missing packages in $category_name:${NC}"
        printf '%s\n' "${missing_packages[@]}"
        echo

        read -r -p "Do you want to install missing packages? (yes/no): " install_choice
        case $install_choice in
            yes|y|Y)
                echo "Installing missing packages..."
                for missing_pkg in "${missing_packages[@]}"; do
                    echo "Installing $missing_pkg..."
                    nix-env -iA nixos."$missing_pkg" 2>/dev/null || \
                    nix-env -iA nixpkgs."$missing_pkg" 2>/dev/null || \
                    echo "Failed to install $missing_pkg (may need different attribute name or system rebuild)"
                done
                ;;
            *)
                echo "Skipping installation."
                ;;
        esac
    else
        echo -e "${GREEN}All packages in $category_name are installed!${NC}"
    fi

    echo
    read -r -p "Press Enter to continue..."
}

# Function to display main menu
show_menu() {
    clear
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${PURPLE}    NIXOS PACKAGE CHECKER${NC}"
    echo -e "${PURPLE}=================================${NC}"
    echo
    echo -e "${CYAN}Packages loaded from: packages.nix${NC}"
    echo

    # Sort the keys numerically and display in order
    for i in $(printf '%s\n' "${!categories[@]}" | sort -n); do
        local category="${categories[$i]}"
        local count=0
        if [[ -n "${packages[$category]}" ]]; then
            count=$(echo "${packages[$category]}" | wc -w)
        fi
        echo -e "${BLUE}$i: ${category}${NC} (${count} packages)"
    done

    echo
    echo -e "${YELLOW}0: Exit${NC}"
    echo -e "${YELLOW}99: Check ALL categories${NC}"
    echo
}

# Function to check all categories
check_all_categories() {
    local i
    # Check categories in numerical order
    for i in $(printf '%s\n' "${!categories[@]}" | sort -n); do
        check_category "${categories[$i]}"
    done
}

# Main program loop
while true; do
    show_menu
    read -r -p "Select category (0-${#categories[@]}): " choice

    case $choice in
        0)
            echo "Goodbye!"
            exit 0
            ;;
        99)
            check_all_categories
            ;;
        [1-9]|[1-2][0-9]|28)
            if [ -n "${categories[$choice]}" ]; then
                check_category "${categories[$choice]}"
            else
                echo -e "${RED}Invalid selection!${NC}"
                sleep 2
            fi
            ;;
        *)
            echo -e "${RED}Invalid selection!${NC}"
            sleep 2
            ;;
    esac
done
