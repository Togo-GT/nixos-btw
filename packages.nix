# /etc/nixos/nixos/system/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ========================
    # CORE SYSTEM TOOLS
    # ========================
    vim                   # Classic terminal text editor
    neovim                # Modern Vim fork with better defaults and Lua support
    micro                 # Simple and intuitive terminal text editor
    wget                  # Command-line utility for downloading files from the web
    curl                  # Tool for transferring data with URL syntax
    curlie                # Frontend to curl that adds ease of use and display
    file                  # Utility to determine file types
    pciutils              # Utilities for inspecting and manipulating PCI devices
    usbutils              # Utilities for inspecting USB devices
    lm_sensors            # Tools for monitoring hardware sensors
    inxi                  # Full featured system information script
    efibootmgr            # Tool to manage UEFI boot entries
    dmidecode             # Tool for dumping DMI/SMBIOS contents
    lshw                  # Tool to provide detailed information on hardware configuration
    lsof                  # Utility to list open files and processes using them
    psmisc                # Utilities that use the proc filesystem (killall, pstree, etc.)
    p7zip                 # 7-zip file archiver with high compression ratio
    unzip                 # Utility for extracting ZIP archives
    zip                   # Compression and file packaging utility
    openssl               # Cryptography and SSL/TLS toolkit
    libnotify             # Library for sending desktop notifications

    # ========================
    # NETWORKMANAGER & NETWORKING TOOLS
    # ========================
    networkmanager                    # Network connection manager and user applications
    networkmanagerapplet              # System tray applet for NetworkManager
    networkmanager-openvpn            # OpenVPN plugin for NetworkManager
    networkmanager-openconnect        # OpenConnect plugin for NetworkManager
    networkmanager-vpnc               # VPNC plugin for NetworkManager
    networkmanager-fortisslvpn        # FortiSSL VPN plugin for NetworkManager
    networkmanager-l2tp               # L2TP plugin for NetworkManager
    networkmanager-strongswan         # StrongSwan plugin for NetworkManager
    net-tools                         # Basic networking tools (ifconfig, netstat, route)
    iproute2                          # Advanced networking tools (ip, ss, tc)
    bind.dnsutils                     # DNS utilities (dig, nslookup, host)
    inetutils                         # Basic network utilities (telnet, ftp, rsh)
    openssh                           # SSH client and server
    wpa_supplicant                    # WPA supplicant for wireless networks
    wpa_supplicant_gui                # GUI for wpa_supplicant
    iw                                # Wireless device configuration utility
    wireless-tools                    # Wireless tools (iwconfig, iwlist)
    aircrack-ng                       # WiFi security auditing tools
    wireshark                         # Network protocol analyzer
    wireshark-cli                     # Command-line version of Wireshark (tshark)
    nmap                              # Network exploration and security auditing tool
    masscan                           # Mass IP port scanner
    iperf3                            # Network bandwidth measurement tool
    speedtest-cli                     # Command line internet speed test
    fast-cli                          # Test download speed using fast.com
    netdiscover                       # Network address discovery tool
    arp-scan                          # ARP scanning and fingerprinting tool
    angry-ip-scanner                  # Fast network scanner with GUI
    zenmap                            # GUI for nmap
    iftop                             # Display bandwidth usage on an interface
    bmon                              # Bandwidth monitor and rate estimator
    nethogs                           # Monitor network usage per process
    bandwhich                         # Terminal bandwidth utilization tool
    vnstat                            # Network traffic monitor with statistics
    darkstat                          # Network traffic analyzer with web interface
    traceroute                        # Print the route packets take to network host
    mtr                               # Network diagnostic tool combining traceroute and ping
    ping                              # Basic network connectivity testing
    prettyping                        # Ping with visual feedback
    httpie                            # Modern command-line HTTP client
    socat                             # Multipurpose relay tool
    netcat-openbsd                    # Networking utility for reading/writing network connections
    openvpn                           # VPN solution using SSL/TLS
    wireguard-tools                   # Tools for WireGuard VPN setup
    tailscale                         # Zero config VPN for secure networks
    softethervpn                      # Multi-protocol VPN software
    pptp                              # Point-to-Point Tunneling Protocol
    dnsmasq                           # Lightweight DNS/DHCP server
    dnstop                            # DNS traffic monitoring
    dnstracer                         # Trace DNS queries through DNS servers
    proxychains                       # Proxy server support for applications
    privoxy                           # Web proxy with advanced filtering
    tcpdump                           # Command-line packet analyzer
    tcpflow                           # Capture and analyze TCP traffic
    ngrep                             # Network grep - search for patterns in network traffic
    netsniff-ng                       # Swiss army knife for network sniffing
    bridge-utils                      # Utilities for configuring Ethernet bridges
    vde2                              # Virtual Distributed Ethernet
    openvswitch                       # Production quality multilayer virtual switch
    modemmanager                      # Mobile broadband modem management service
    usb_modeswitch                    # Mode switching tool for USB devices
    ettercap                          # Comprehensive suite for man-in-the-middle attacks
    driftnet                          # Captures and displays images from network traffic
    sslscan                           # SSL/TLS scanner
    testssl.sh                        # TLS/SSL encryption testing tool
    smbclient                         # SMB/CIFS client utilities
    nfs-utils                         # NFS client and server utilities
    ftp                               # Classic file transfer protocol client
    lftp                              # Sophisticated file transfer program
    sshfs                             # Filesystem client for SSH
    curlftpfs                         # Filesystem for accessing FTP hosts
    networkmanager_dmenu              # dmenu script for NetworkManager
    networkmanager-iodine             # Iodine DNS tunnel plugin for NetworkManager
    networkmanager-ssh                # SSH plugin for NetworkManager
    lynx                              # Text-based web browser
    links2                            # Graphical and text web browser
    elinks                            # Advanced text-based web browser

    # ========================
    # PACKAGE MANAGEMENT (NIX)
    # ========================
    home-manager          # Manage user environments using Nix
    nix-index             # Fast filesystem index for nix-locate
    nix-search            # Search for packages in NixOS
    nixd                  # Nix language server
    nix-tree              # Visualize nix package dependencies
    nix-diff              # Explain why two Nix derivations differ
    nix-output-monitor    # Monitor nix build progress with enhanced output
    nix-du                # Visualize nix store usage
    nixos-option          # Inspect NixOS configuration options
    comma                 # Run programs without installing them
    nixpkgs-fmt           # Formatter for Nix code
    nixfmt-classic        # Alternative formatter for Nix code
    statix                # Lints and suggestions for Nix code
    alejandra             # Fast formatter for Nix code
    manix                 # Search NixOS manual pages
    cachix                # Binary cache management for Nix
    direnv                # Environment switcher for the shell
    nixos-generators      # Generate NixOS installation media
    nh                    # Nix helper for convenient package management
    nil                   # Nix language server
  # rnix-lsp              # Alternative Nix language server

    # ========================
    # SHELL & TERMINAL
    # ========================
    zoxide                # Faster way to navigate directories
    starship              # Cross-shell prompt with customization
    oh-my-posh            # Prompt theme engine
    fish                  # User-friendly command line shell
    zsh                   # Powerful shell with extensive customization
    tmux                  # Terminal multiplexer for managing multiple sessions
    tmuxp                 # Tmux session manager

    # ========================
    # HARDWARE INFORMATION
    # ========================
    pciutils              # PCI device inspection utilities (lspci)
    usbutils              # USB device inspection utilities (lsusb)
    lm_sensors            # Hardware monitoring sensors
    inxi                  # Comprehensive system information tool
    dmidecode             # DMI table decoder for hardware info
    lshw                  # Detailed hardware lister

    # ========================
    # POWER MANAGEMENT
    # ========================
    powertop              # Power consumption monitoring and optimization
    acpi                  # Shows battery status and thermal information
    cpupower-gui          # GUI for CPU frequency scaling
    powerstat             # Measure power consumption of a laptop
    smartmontools         # SMART disk monitoring and health checking
    s-tui                 # Terminal UI for stress testing and monitoring
    stress-ng             # Stress test utility for Linux systems

    # ========================
    # STORAGE & FILESYSTEMS
    # ========================
    gnome-disk-utility    # Disk management and benchmarking tool
    gparted               # Partition editor for graphical disk management
    ncdu                  # Disk usage analyzer with NCurses interface
    duf                   # Disk usage/free utility with better output
    agedu                 # Track down wasted disk space
    rsync                 # Fast and versatile file copying tool
    btrfs-progs           # Btrfs filesystem utilities
    xfsprogs              # XFS filesystem utilities
    e2fsprogs             # Ext2/3/4 filesystem utilities
    mdadm                 # RAID management utilities
    lvm2                  # Logical Volume Manager tools
    cryptsetup            # Disk encryption setup tool
    nvme-cli              # NVM-Express user space tooling
    util-linux            # Collection of basic system utilities
    testdisk              # Data recovery tool for lost partitions
    gsmartcontrol         # GUI for SMART monitoring tools
    ntfs3g                # NTFS filesystem driver with read/write support
    borgbackup            # Deduplicating backup program
    rsnapshot             # Filesystem snapshot utility for backups

    # ========================
    # GRAPHICS & GPU
    # ========================
    nvidia-vaapi-driver   # VA-API implementation for NVIDIA hardware
    nvitop                # NVIDIA GPU status and process monitoring
    vulkan-tools          # Vulkan utilities and demos
    vulkan-loader         # Vulkan loader and validation layers
    mesa-demos            # Mesa 3D graphics demo applications
    libva-utils           # VA-API utilities for hardware acceleration
    vdpauinfo             # Tool to query VDPAU capabilities
    clinfo                # OpenCL platform and device information
    glmark2               # OpenGL ES and GL benchmark
    gpu-viewer            # GUI for viewing GPU information and usage
    intel-gpu-tools       # Tools for debugging Intel GPUs
    dxvk                  # Vulkan-based translation layer for Direct3D
    vkd3d-proton          # Direct3D 12 to Vulkan translation layer
    vkbasalt              # Vulkan post processing layer for Linux

    # ========================
    # AUDIO
    # ========================
    pulsemixer            # CLI and curses mixer for PulseAudio
    pavucontrol           # PulseAudio volume control GUI
    alsa-utils            # ALSA sound system utilities
    easyeffects           # Audio effects for PipeWire applications
    carla                 # Audio plugin host and patchbay
    helvum                # PipeWire patchbay in Rust
    qjackctl              # JACK Audio Connection Kit Qt GUI interface
    jack2                 # Audio server for professional audio

    # ========================
    # DEVELOPMENT TOOLS
    # ========================
    gcc                   # GNU Compiler Collection
    gnumake               # GNU make build tool
    pkg-config            # Helper tool for compiling with libraries
    cmake                 # Cross-platform build system
    gdb                   # GNU debugger
    strace                # System call tracer
    ltrace                # Library call tracer
    valgrind              # Memory debugging and profiling tool
    shellcheck            # Shell script static analysis tool
    hadolint              # Dockerfile linter

    # ========================
    # PROGRAMMING LANGUAGES
    # ========================
    python3               # Python programming language
    python3Packages.pip   # Python package installer
    pipx                  # Install and run Python applications in isolated environments
    go                    # Go programming language
    nodejs                # JavaScript runtime built on Chrome's V8
    perl                  # Perl programming language
    rustup                # Rust toolchain installer

    # ========================
    # DEVELOPMENT UTILITIES
    # ========================
    jq                    # Command-line JSON processor
    yq                    # Command-line YAML processor
    hexyl                 # Command-line hex viewer
    hyperfine             # Command-line benchmarking tool
    tokei                 # Count lines of code quickly
    binutils              # GNU binary utilities

    # ========================
    # LANGUAGE SERVERS
    # ========================
    nodePackages.bash-language-server      # Bash language server
    nodePackages.typescript-language-server # TypeScript language server
    nodePackages.vscode-langservers-extracted # HTML/CSS/JSON language servers
    rust-analyzer                          # Rust language server
    python3Packages.python-lsp-server      # Python language server
    lua-language-server                    # Lua language server
    marksman                               # Markdown language server
    clang-tools                            # Clang tools including clangd

    # ========================
    # CONTAINERS & VIRTUALIZATION
    # ========================
    docker                # Platform for building and running containerized applications
    docker-compose        # Tool for defining and running multi-container Docker applications
    podman                # Daemonless container engine
    distrobox             # Use any Linux distribution inside your terminal
    virt-manager          # Desktop user interface for managing virtual machines
    virt-viewer           # Viewer for remote virtual machines
    qemu                  # Generic machine emulator and virtualizer (includes KVM)
    qemu-utils            # QEMU utilities
    qemu_full             # QEMU with all optional features
    quickemu              # Quickly create and run optimised Windows/macOS VMs
    libvirt               # Toolkit to manage virtualization platforms
    spice                 # SPICE remote computing protocol
    spice-gtk             # GTK+ SPICE client
    spice-protocol        # SPICE protocol headers
    spice-vdagent         # SPICE guest agent
    vde2                  # Virtual Distributed Ethernet
    bridge-utils          # Utilities for configuring Ethernet bridges
    dnsmasq               # Lightweight DNS/DHCP server
    OVMF                  # UEFI firmware for virtual machines
    virtualbox            # General-purpose virtualizer
    vagrant               # Tool for building and managing virtual machine environments
    libguestfs            # Tools for accessing and modifying VM disk images
    guestfs-tools         # Command line tools for libguestfs
    openvswitch           # Production quality multilayer virtual switch
    virt-top              # Top-like utility for virtual machines

    # ========================
    # INFRASTRUCTURE & DEVOPS
    # ========================
    ansible               # Configuration management and deployment tool
    packer                # Tool for creating machine images
    terraform             # Infrastructure as code tool

    # ========================
    # SECURITY
    # ========================
    age                   # Simple, modern and secure file encryption
    sops                  # Secrets management tool
    # (aircrack-ng, ettercap already included above)

    # ========================
    # CLI PRODUCTIVITY
    # ========================
    eza                   # Modern replacement for ls
    bat                   # Cat clone with syntax highlighting
    bat-extras.batdiff    # Diff with syntax highlighting
    bat-extras.batman     # Manual pages with syntax highlighting
    bat-extras.batpipe    # Prettify pipe output
    fd                    # Simple and fast alternative to find
    ripgrep               # Line-oriented search tool
    ripgrep-all           # Ripgrep with additional file support
    fzf                   # Command-line fuzzy finder
    bottom                # Graphical process/system monitor for terminal
    dust                  # More intuitive version of du
    procs                 # Modern replacement for ps
    sd                    # Intuitive find and replace CLI
    choose                # Human-friendly and fast alternative to cut
    fselect               # Find files with SQL-like queries
    tree                  # Display directory structure as tree
    broot                 # Quick way to navigate directory trees
    watch                 # Execute program periodically and show output

    # ========================
    # GIT TOOLS
    # ========================
    git                   # Distributed version control system
    gitFull               # Git with all optional features
    git-extras            # Git extension scripts
    delta                 # Syntax-highlighting pager for git
    lazygit               # Terminal UI for git commands
    github-cli            # Official GitHub CLI tool
    git-crypt             # Transparent file encryption in git
    git-open              # Open repository website from terminal
    git-revise            # Efficiently update, split, and rearrange commits
    gitui                 # Terminal UI for git
    gitflow               # Git extensions for workflow
    tig                   # Text-mode interface for git

    # ========================
    # FILE MANAGEMENT
    # ========================
    ranger                # Terminal file manager with VI key bindings
    nnn                   # Tiny and fast terminal file manager
    fff                   # Simple and fast file manager
    mc                    # Midnight Commander file manager
    lf                    # Terminal file manager with inspiration from ranger

    # ========================
    # MULTIMEDIA
    # ========================
    ffmpeg                # Complete solution to record, convert and stream audio/video
    mpv                   # Free, open source media player
    imagemagick           # Create, edit, compose, or convert bitmap images
    audacity              # Cross-platform audio editor
    handbrake             # Video transcoder tool
    vlc                   # Cross-platform multimedia player
    gimp                  # GNU Image Manipulation Program
    inkscape              # Vector graphics editor
    krita                 # Professional free and open source painting program
    obs-studio            # Software for video recording and live streaming

    # ========================
    # GAMING
    # ========================
    steam                 # Digital distribution platform for games
    lutris                # Gaming platform for Linux
    wine                  # Compatibility layer for running Windows applications
    wineWowPackages.stable # Wine for both 32 and 64 bit applications
    winetricks            # Package manager for Wine
    protontricks          # Winetricks wrapper for Proton and Steam
    mangohud              # Vulkan and OpenGL overlay for monitoring FPS and system info
    goverlay              # Graphical interface for MangoHud and other overlays
    gamemode              # Optimise Linux system performance for games

    # ========================
    # GUI APPLICATIONS
    # ========================
    chromium              # Open-source web browser
    firefox               # Free and open-source web browser
    signal-desktop        # Private messaging application
    telegram-desktop      # Messaging app with focus on speed and security
    thunderbird           # Email, RSS, and newsgroup client
    spotify               # Music streaming service
    kdePackages.okular    # Universal document viewer
    zathura               # Minimalistic document viewer with vim-like controls
    kdePackages.dolphin   # File manager for KDE
    evince                # Document viewer for multiple formats
    feh                   # Lightweight image viewer
    kdePackages.konsole   # Terminal emulator for KDE
    paprefs               # PulseAudio preferences GUI
    protonup-qt           # Install and manage Proton-GE and other compatibility tools
    transmission_4-qt     # Fast and easy BitTorrent client (Qt version)
    vscode                # Code editor redefined and optimized for building/debugging
    keepassxc             # Cross-platform password manager

    # ========================
    # SYSTEM MONITORING
    # ========================
    neofetch              # System information tool with ASCII art
    onefetch              # Git repository summary in command line
    fastfetch             # Fast system information tool
    gotop                 # Terminal based graphical activity monitor
    btop                  # Modern and resource monitor for terminal
    htop                  # Interactive process viewer and system monitor
    iotop                 # Monitor disk I/O usage
    nethogs               # Monitor network usage per process
    bandwhich             # Terminal bandwidth utilization tool
    zenith                # Terminal system monitor with charts
    dool                  # Performance monitoring tool (formerly dstat)
    mission-center        # System monitoring center for GNOME
    glances               # Cross-platform system monitoring tool
    netdata               # Real-time performance monitoring

    # ========================
    # INFORMATION & DOCUMENTATION
    # ========================
    tldr                  # Simplified and community-driven man pages
    cheat                 # Create and view interactive cheatsheets
    taskwarrior3          # Command-line task management tool

    # ========================
    # QT6 PACKAGES FOR PLASMA 6 + KDE APPS
    # ========================
    qt6.qtbase            # Qt6 base modules
    qt6.qtdeclarative     # Qt6 QML and Quick modules
    qt6.qttools           # Qt6 tools and utilities
    qt6.qtwayland         # Qt6 Wayland support
    qt6.qtmultimedia      # Qt6 multimedia support
    qt6.qtsvg             # Qt6 SVG support
    qt6.qtwebengine       # Qt6 WebEngine components

    # ========================
    # LOGITECH / GAMING MOUSE SUPPORT
    # ========================
    libratbag             # DBus daemon to configure gaming mice
    piper                 # GTK application to configure gaming mice

    # ========================
    # THEMES & APPEARANCE
    # ========================
    catppuccin-kde        # Catppuccin theme for KDE Plasma
    catppuccin-gtk        # Catppuccin theme for GTK applications
    tela-circle-icon-theme # Tela circle icon theme
    papirus-icon-theme    # Papirus icon theme

    # ========================
    # FUN & ENTERTAINMENT
    # ========================
    cowsay                # Configurable talking cow
    fortune               # Display a random fortune
    sl                    # Steam locomotive animation for mistyped 'ls'
    asciiquarium          # Animated ASCII aquarium
    cbonsai               # Grow random bonsai trees in your terminal
    cmatrix               # Show a scrolling Matrix-like screen
    figlet                # Create large letters from ordinary text
    # (speedtest-cli already included above)
    # (fast-cli already included above)
    termscp               # Feature rich terminal file transfer
    cava                  # Console-based audio visualizer
    pipes-rs              # Rust implementation of pipes.sh
    lolcat                # Rainbow coloring for text output
  ];
}
