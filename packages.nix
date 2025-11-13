# packages.nix - System package collection
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # =========================================
    # CORE SYSTEM UTILITIES
    # =========================================
    vim                   # Classic terminal text editor
    neovim                # Modern Vim fork with Lua support
    micro                 # Simple and intuitive terminal editor
    wget                  # Command-line file download utility
    curl                  # Data transfer tool with URL syntax
    curlie                # User-friendly curl frontend
    file                  # File type identification utility
    pciutils              # PCI device inspection tools
    usbutils              # USB device inspection tools
    lm_sensors            # Hardware sensor monitoring
    inxi                  # Comprehensive system information script
    efibootmgr            # UEFI boot entry management
    dmidecode             # DMI/SMBIOS table decoder
    lshw                  # Detailed hardware configuration lister
    lsof                  # List open files and processes
    psmisc                # Proc filesystem utilities
    p7zip                 # High compression ratio archiver
    unzip                 # ZIP archive extraction
    zip                   # File compression and packaging
    openssl               # Cryptography and SSL/TLS toolkit
    libnotify             # Desktop notification library

    # =========================================
    # NIX PACKAGE MANAGEMENT TOOLS
    # =========================================
    home-manager          # User environment management with Nix
    nix-index             # Fast filesystem index for nix-locate
    nix-search            # Package search utility for NixOS
    nixd                  # Nix language server
    nix-tree              # Visualize nix package dependencies
    nix-diff              # Compare nix derivations
    nix-output-monitor    # Enhanced nix build progress monitor
    nix-du                # Visualize nix store disk usage
    nixos-option          # Inspect NixOS configuration options
    comma                 # Run programs without installation
    nixpkgs-fmt           # Nix code formatter
    nixfmt-classic        # Alternative Nix code formatter
    statix                # Linter and suggestions for Nix code
    alejandra             # Fast Nix code formatter
    manix                 # Search NixOS manual pages
    cachix                # Binary cache management
    direnv                # Shell environment switcher
    nixos-generators      # NixOS installation media generator
    nh                    # Nix helper for package management
    nil                   # Nix language server implementation

    # =========================================
    # SHELL AND TERMINAL TOOLS
    # =========================================
    zoxide                # Smart directory navigation
    starship              # Customizable cross-shell prompt
    oh-my-posh            # Prompt theme engine
    fish                  # User-friendly command shell
    zsh                   # Powerful customizable shell
    tmux                  # Terminal multiplexer
    tmuxp                 # Tmux session manager

    # =========================================
    # HARDWARE INFORMATION TOOLS
    # =========================================
    pciutils              # lspci for PCI device info
    usbutils              # lsusb for USB device info
    lm_sensors            # Hardware sensor data
    inxi                  # Comprehensive system info
    dmidecode             # Hardware DMI information
    lshw                  # Detailed hardware listing

    # =========================================
    # POWER MANAGEMENT TOOLS
    # =========================================
    powertop              # Power consumption monitoring
    acpi                  # Battery status and thermal info
    cpupower-gui          # CPU frequency scaling GUI
    powerstat             # Laptop power consumption measurement
    smartmontools         # Disk SMART monitoring
    s-tui                 # Stress test UI with monitoring
    stress-ng             # System stress testing utility

    # =========================================
    # STORAGE AND FILESYSTEM TOOLS
    # =========================================
    gnome-disk-utility    # Disk management and benchmarking
    gparted               # Graphical partition editor
    ncdu                  # NCurses disk usage analyzer
    duf                   # Better disk usage utility
    agedu                 # Disk space usage tracking
    rsync                 # Versatile file copying tool
    btrfs-progs           # Btrfs filesystem utilities
    xfsprogs              # XFS filesystem utilities
    e2fsprogs             # Ext2/3/4 filesystem utilities
    mdadm                 # RAID management utilities
    lvm2                  # Logical Volume Manager tools
    cryptsetup            # Disk encryption setup
    nvme-cli              # NVMe storage management
    util-linux            # Basic system utilities collection
    testdisk              # Partition recovery tool
    gsmartcontrol         # GUI for SMART disk monitoring
    ntfs3g                # NTFS filesystem driver
    borgbackup            # Deduplicating backup program
    rsnapshot             # Filesystem snapshot backup utility

    # =========================================
    # GRAPHICS AND GPU TOOLS
    # =========================================
    nvidia-vaapi-driver   # VA-API implementation for NVIDIA
    nvitop                # NVIDIA GPU status monitor
    vulkan-tools          # Vulkan utilities and demos
    vulkan-loader         # Vulkan loader and validation
    mesa-demos            # Mesa 3D graphics demos
    libva-utils           # VA-API hardware acceleration utilities
    vdpauinfo             # VDPAU capability query tool
    clinfo                # OpenCL platform information
    glmark2               # OpenGL ES and GL benchmark
    gpu-viewer            # GPU information and usage viewer
    intel-gpu-tools       # Intel GPU debugging tools
    dxvk                  # Direct3D to Vulkan translation
    vkd3d-proton          # Direct3D 12 to Vulkan translation
    vkbasalt              # Vulkan post processing layer

    # =========================================
    # AUDIO TOOLS AND UTILITIES
    # =========================================
    pulsemixer            # CLI and curses PulseAudio mixer
    pavucontrol           # PulseAudio volume control GUI
    alsa-utils            # ALSA sound system utilities
    easyeffects           # Audio effects for PipeWire
    carla                 # Audio plugin host and patchbay
    helvum                # PipeWire patchbay in Rust
    qjackctl              # JACK Audio Connection Kit GUI
    jack2                 # Professional audio server

    # =========================================
    # DEVELOPMENT TOOLS AND COMPILERS
    # =========================================
    gcc                   # GNU Compiler Collection
    gnumake               # GNU make build tool
    pkg-config            # Library compilation helper
    cmake                 # Cross-platform build system
    gdb                   # GNU debugger
    strace                # System call tracer
    ltrace                # Library call tracer
    valgrind              # Memory debugging and profiling
    shellcheck            # Shell script static analysis
    hadolint              # Dockerfile linter

    # =========================================
    # PROGRAMMING LANGUAGES
    # =========================================
    python3               # Python programming language
    python3Packages.pip   # Python package installer
    pipx                  # Isolated Python application installer
    go                    # Go programming language
    nodejs                # JavaScript runtime
    perl                  # Perl programming language
    rustup                # Rust toolchain installer

    # =========================================
    # DEVELOPMENT UTILITIES
    # =========================================
    jq                    # Command-line JSON processor
    yq                    # Command-line YAML processor
    hexyl                 # Command-line hex viewer
    hyperfine             # Command-line benchmarking
    tokei                 # Fast code line counter
    binutils              # GNU binary utilities

    # =========================================
    # LANGUAGE SERVERS
    # =========================================
    nodePackages.bash-language-server      # Bash language server
    nodePackages.typescript-language-server # TypeScript language server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON servers
    rust-analyzer                          # Rust language server
    python3Packages.python-lsp-server      # Python language server
    lua-language-server                    # Lua language server
    marksman                               # Markdown language server
    clang-tools                            # Clang tools including clangd

    # =========================================
    # CONTAINERS AND VIRTUALIZATION
    # =========================================
    docker                # Container platform
    docker-compose        # Multi-container Docker applications
    podman                # Daemonless container engine
    distrobox             # Linux distribution terminal container
    virt-manager          # Virtual machine management GUI
    virt-viewer           # Remote VM viewer
    qemu                  # Machine emulator and virtualizer
    qemu-utils            # QEMU utilities
    qemu_full             # QEMU with all features
    quickemu              # Optimized Windows/macOS VM creator
    libvirt               # Virtualization platform toolkit
    spice                 # SPICE remote computing protocol
    spice-gtk             # GTK+ SPICE client
    spice-protocol        # SPICE protocol headers
    spice-vdagent         # SPICE guest agent
    vde2                  # Virtual Distributed Ethernet
    bridge-utils          # Ethernet bridge configuration
    dnsmasq               # Lightweight DNS/DHCP server
    OVMF                  # UEFI firmware for virtual machines
    virtualbox            # General-purpose virtualizer
    vagrant               # Virtual machine environment manager
    libguestfs            # VM disk image access tools
    guestfs-tools         # Command line libguestfs tools
    openvswitch           # Multilayer virtual switch
    virt-top              # Top-like utility for VMs

    # =========================================
    # TPM AND SECURITY HARDWARE TOOLS
    # =========================================
    swtpm                 # Software TPM emulator for VMs
    edk2                  # Alternative UEFI firmware implementation
    tpm2-tools            # TPM 2.0 management tools

    # =========================================
    # INFRASTRUCTURE AND DEVOPS TOOLS
    # =========================================
    ansible               # Configuration management
    packer                # Machine image creation
    terraform             # Infrastructure as code

    # =========================================
    # NETWORK TOOLS AND UTILITIES
    # =========================================
    networkmanagerapplet  # NetworkManager system tray applet
    wireshark             # Network protocol analyzer
    nmap                  # Network exploration and security
    masscan               # Mass IP port scanner
    iperf3                # Network bandwidth measurement
    traceroute            # Network route tracing
    mtr                   # Combined traceroute and ping
    ipcalc                # IP network settings calculator
    iftop                 # Interface bandwidth usage
    bmon                  # Bandwidth monitor and estimator
    netcat-openbsd        # Network connection utility
    socat                 # Multipurpose relay tool
    tcpdump               # Command-line packet analyzer
    tcpflow               # TCP traffic capture and analysis
    httpie                # Modern HTTP client
    sshpass               # Non-interactive SSH authentication
    sshfs                 # SSH filesystem client
    whois                 # Domain information client
    macchanger            # MAC address manipulation
    openvpn               # SSL/TLS VPN solution
    tailscale             # Zero config VPN
    wireguard-tools       # WireGuard VPN setup tools
    inetutils             # Basic network utilities
    bind                  # DNS server utilities
    openssh               # SSH client and server

    # =========================================
    # SECURITY TOOLS
    # =========================================
    age                   # Modern file encryption
    sops                  # Secrets management tool
    aircrack-ng           # WiFi security auditing
    ettercap              # Man-in-the-middle attack suite

    # =========================================
    # CLI PRODUCTIVITY TOOLS
    # =========================================
    eza                   # Modern ls replacement
    bat                   # Syntax highlighting cat
    bat-extras.batdiff    # Syntax highlighted diff
    bat-extras.batman     # Syntax highlighted man pages
    bat-extras.batpipe    # Prettified pipe output
    fd                    # Fast find alternative
    ripgrep               # Line-oriented search tool
    ripgrep-all           # Extended file support ripgrep
    fzf                   # Command-line fuzzy finder
    bottom                # Graphical terminal monitor
    dust                  # Intuitive du replacement
    procs                 # Modern ps replacement
    sd                    # Find and replace CLI
    choose                # User-friendly cut alternative
    fselect               # SQL-like file finder
    tree                  # Directory structure display
    broot                 # Directory tree navigation
    watch                 # Periodic command execution

    # =========================================
    # GIT TOOLS AND UTILITIES
    # =========================================
    git                   # Version control system
    gitFull               # Git with all features
    git-extras            # Git extension scripts
    delta                 # Syntax highlighting git pager
    lazygit               # Terminal UI for git
    github-cli            # Official GitHub CLI
    git-crypt             # Git file encryption
    git-open              # Open repository website
    git-revise            # Efficient commit editing
    gitui                 # Terminal git UI
    gitflow               # Git workflow extensions
    tig                   # Text-mode git interface

    # =========================================
    # FILE MANAGEMENT TOOLS
    # =========================================
    ranger                # VI-key file manager
    nnn                   # Fast terminal file manager
    fff                   # Simple file manager
    mc                    # Midnight Commander
    lf                    # Ranger-inspired file manager

    # =========================================
    # MULTIMEDIA TOOLS
    # =========================================
    ffmpeg                # Audio/video processing
    mpv                   # Media player
    imagemagick           # Image manipulation
    audacity              # Audio editor
    handbrake             # Video transcoder
    vlc                   # Multimedia player
    gimp                  # Image manipulation program
    inkscape              # Vector graphics editor
    krita                 # Digital painting
    obs-studio            # Video recording and streaming

    # =========================================
    # GAMING TOOLS AND PLATFORMS
    # =========================================
    steam                 # Game distribution platform
    lutris                # Gaming platform
    wine                  # Windows compatibility layer
    wineWowPackages.stable # 32/64 bit Wine
    winetricks            # Wine package manager
    protontricks          # Proton and Steam wrapper
    mangohud              # FPS and system overlay
    goverlay              # Overlay configuration GUI
    gamemode              # System performance optimizer

    # =========================================
    # GUI APPLICATIONS
    # =========================================
    chromium              # Open-source browser
    firefox               # Web browser
    signal-desktop        # Private messaging
    telegram-desktop      # Messaging app
    thunderbird           # Email client
    spotify               # Music streaming
    kdePackages.okular    # Document viewer
    zathura               # Minimal document viewer
    kdePackages.dolphin   # KDE file manager
    evince                # Document viewer
    feh                   # Image viewer
    kdePackages.konsole   # KDE terminal
    paprefs               # PulseAudio preferences
    protonup-qt           # Compatibility tools manager
    transmission_4-qt     # BitTorrent client
    vscode                # Code editor
    keepassxc             # Password manager

    # =========================================
    # SYSTEM MONITORING TOOLS
    # =========================================
    neofetch              # System information with ASCII
    onefetch              # Git repository summary
    fastfetch             # Fast system information
    gotop                 # Graphical activity monitor
    btop                  # Modern resource monitor
    htop                  # Interactive process viewer
    iotop                 # Disk I/O monitor
    nethogs               # Per-process network usage
    bandwhich             # Terminal bandwidth utilization
    zenith                # System monitor with charts
    dool                  # Performance monitoring
    mission-center        # GNOME system monitoring
    glances               # Cross-platform monitoring
    netdata               # Real-time performance monitoring

    # =========================================
    # INFORMATION AND DOCUMENTATION
    # =========================================
    tldr                  # Simplified man pages
    cheat                 # Interactive cheatsheets
    taskwarrior3          # Command-line task management

    # =========================================
    # QT6 PACKAGES FOR PLASMA 6
    # =========================================
    qt6.qtbase            # Qt6 base modules
    qt6.qtdeclarative     # Qt6 QML and Quick
    qt6.qttools           # Qt6 tools
    qt6.qtwayland         # Qt6 Wayland support
    qt6.qtmultimedia      # Qt6 multimedia
    qt6.qtsvg             # Qt6 SVG support
    qt6.qtwebengine       # Qt6 WebEngine

    # =========================================
    # GAMING PERIPHERAL SUPPORT
    # =========================================
    libratbag             # Gaming mouse configuration
    piper                 # Gaming mouse GUI configurator

    # =========================================
    # THEMES AND APPEARANCE
    # =========================================
    catppuccin-kde        # Catppuccin theme for KDE
    catppuccin-gtk        # Catppuccin theme for GTK
    tela-circle-icon-theme # Tela circle icons
    papirus-icon-theme    # Papirus icon theme

    # =========================================
    # TERMINAL FUN AND ENTERTAINMENT
    # =========================================
    cowsay                # Talking cow
    fortune               # Random fortunes
    sl                    # Steam locomotive animation
    asciiquarium          # ASCII aquarium
    cbonsai               # Bonsai tree generator
    cmatrix               # Matrix-like screen
    figlet                # Large text generator
    speedtest-cli         # Internet speed test
    fast-cli              # fast.com speed test
    termscp               # Terminal file transfer
    cava                  # Audio visualizer
    pipes-rs              # Pipes implementation
    lolcat                # Rainbow text coloring
  ];
}
