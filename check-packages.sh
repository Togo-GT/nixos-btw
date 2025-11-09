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

# Package lists for each category
declare -A packages=(
    ["CORE SYSTEM TOOLS"]="vim neovim micro wget curl curlie file pciutils usbutils lm_sensors inxi efibootmgr dmidecode lshw lsof psmisc p7zip unzip zip openssl libnotify"
    ["PACKAGE MANAGEMENT (NIX)"]="home-manager nix-index nix-search nixd nix-tree nix-diff nix-output-monitor nix-du nixos-option comma nixpkgs-fmt nixfmt-classic statix alejandra manix cachix direnv nixos-generators nh nil rnix-lsp"
    ["SHELL & TERMINAL"]="zoxide starship oh-my-posh fish zsh tmux tmuxp"
    ["HARDWARE INFORMATION"]="pciutils usbutils lm_sensors inxi dmidecode lshw"
    ["POWER MANAGEMENT"]="powertop acpi cpupower-gui powerstat smartmontools s-tui stress-ng"
    ["STORAGE & FILESYSTEMS"]="gnome-disk-utility gparted ncdu duf agedu rsync btrfs-progs xfsprogs e2fsprogs mdadm lvm2 cryptsetup nvme-cli util-linux testdisk gsmartcontrol ntfs3g borgbackup rsnapshot"
    ["GRAPHICS & GPU"]="nvidia-vaapi-driver nvitop vulkan-tools vulkan-loader mesa-demos libva-utils vdpauinfo clinfo glmark2 gpu-viewer intel-gpu-tools dxvk vkd3d-proton vkbasalt"
    ["AUDIO"]="pulsemixer pavucontrol alsa-utils easyeffects carla helvum qjackctl jack2"
    ["DEVELOPMENT TOOLS"]="gcc gnumake pkg-config cmake gdb strace ltrace valgrind shellcheck hadolint"
    ["PROGRAMMING LANGUAGES"]="python3 python3Packages.pip pipx go nodejs perl rustup"
    ["DEVELOPMENT UTILITIES"]="jq yq hexyl hyperfine tokei binutils"
    ["LANGUAGE SERVERS"]="nodePackages.bash-language-server nodePackages.typescript-language-server nodePackages.vscode-langservers-extracted rust-analyzer python3Packages.python-lsp-server lua-language-server marksman clang-tools"
    ["CONTAINERS & VIRTUALIZATION"]="docker docker-compose podman distrobox virt-manager virt-viewer qemu qemu_kvm qemu-utils quickemu libvirt spice spice-gtk spice-protocol spice-vdagent vde2 bridge-utils dnsmasq OVMF virtualbox vagrant libguestfs guestfs-tools openvswitch virt-top"
    ["INFRASTRUCTURE & DEVOPS"]="ansible packer terraform"
    ["NETWORK TOOLS"]="networkmanagerapplet wireshark nmap masscan iperf3 traceroute mtr ipcalc iftop bmon netcat-openbsd socat tcpdump tcpflow httpie sshpass sshfs whois macchanger openvpn tailscale wireguard-tools inetutils bind openssh"
    ["SECURITY"]="age sops aircrack-ng ettercap"
    ["CLI PRODUCTIVITY"]="eza bat bat-extras.batdiff bat-extras.batman bat-extras.batpipe fd ripgrep ripgrep-all fzf bottom dust procs sd choose fselect tree broot watch"
    ["GIT TOOLS"]="git gitFull git-extras delta lazygit github-cli git-crypt git-open git-revise gitui gitflow tig"
    ["FILE MANAGEMENT"]="ranger nnn fff mc lf"
    ["MULTIMEDIA"]="ffmpeg mpv imagemagick audacity handbrake vlc gimp inkscape krita obs-studio"
    ["GAMING"]="steam lutris wine wineWowPackages.stable winetricks protontricks mangohud goverlay gamemode"
    ["GUI APPLICATIONS"]="chromium firefox signal-desktop telegram-desktop thunderbird spotify kdePackages.okular zathura kdePackages.dolphin evince feh kdePackages.konsole paprefs protonup-qt transmission_4-qt vscode keepassxc"
    ["SYSTEM MONITORING"]="neofetch onefetch fastfetch gotop btop htop iotop nethogs bandwhich zenith dool mission-center glances netdata"
    ["INFORMATION & DOCUMENTATION"]="tldr cheat taskwarrior3"
    ["QT6 PACKAGES"]="qt6.qtbase qt6.qtdeclarative qt6.qttools qt6.qtwayland qt6.qtmultimedia qt6.qtsvg qt6.qtwebengine"
    ["LOGITECH / GAMING MOUSE SUPPORT"]="libratbag piper"
    ["THEMES & APPEARANCE"]="catppuccin-kde catppuccin-gtk tela-circle-icon-theme papirus-icon-theme"
    ["FUN & ENTERTAINMENT"]="cowsay fortune sl asciiquarium cbonsai cmatrix figlet speedtest-cli fast-cli termscp cava pipes-rs lolcat"
)

# Function to check if a package is installed
check_package() {
    local package=$1

    # Try different methods to check if package is available
    if command -v "$package" &> /dev/null; then
        return 0
    elif nix-locate --installed "$package" &> /dev/null; then
        return 0
    elif [ -d "/run/current-system/sw/bin/$package" ] || [ -f "/run/current-system/sw/bin/$package" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get package version
get_package_version() {
    local package=$1
    local version=""

    case $package in
        vim|neovim)
            version=$("$package" --version 2>/dev/null | head -n 1)
            ;;
        wget|curl|git|python3|node|go|perl|rustc|gcc|make|cmake|docker|podman|ansible|terraform)
            version=$("$package" --version 2>/dev/null | head -n 1)
            ;;
        *)
            # Try to get version with --version flag
            if "$package" --version &>/dev/null; then
                version=$("$package" --version 2>/dev/null | head -n 1)
            fi
            ;;
    esac

    echo "$version"
}

# Function to check all packages in a category
check_category() {
    local category_name=$1
    local package_list=${packages[$category_name]}

    echo -e "${CYAN}=== Checking $category_name ===${NC}"
    echo

    local missing_packages=()

    for package in $package_list; do
        # Clean package name (remove nix store paths or prefixes)
        clean_package="${package//*./}" # Remove prefixes like kdePackages.

        if check_package "$clean_package"; then
            version=$(get_package_version "$clean_package")
            if [ -n "$version" ]; then
                echo -e "${GREEN}✓ $clean_package${NC}"
                echo -e "  Version: $version"
            else
                echo -e "${GREEN}✓ $clean_package = ok${NC}"
            fi
        else
            echo -e "${RED}✗ $clean_package = no${NC}"
            missing_packages+=("$clean_package")
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
                    nix-env -iA nixos."$missing_pkg" || echo "Failed to install $missing_pkg"
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

    # Sort the keys numerically and display in order
    for i in $(printf '%s\n' "${!categories[@]}" | sort -n); do
        echo -e "${BLUE}$i: ${categories[$i]}${NC}"
    done

    echo
    echo -e "${YELLOW}0: Exit${NC}"
    echo -e "${YELLOW}99: Check ALL categories${NC}"
    echo
}

# Function to check all categories
check_all_categories() {
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
