{ config, pkgs, unstable, ... }:

let
  systemPackages = with pkgs; [
    # =====================================
    # FILE MANAGEMENT TOOLS
    # =====================================
    broot      # Terminal file manager with overview
    dust       # More intuitive version of du
    duf        # Disk usage/free utility
    fselect    # Find files with SQL-like queries
    ncdu       # NCurses disk usage analyzer
    zoxide     # Faster directory navigation (replacement for cd)
    tree       # Display directory structure as tree

    # =====================================
    # TEXT EDITING AND PROCESSING
    # =====================================
    bat                    # Cat clone with syntax highlighting
    bat-extras.batdiff     # Git diff with syntax highlighting
    bat-extras.batgrep     # Grep with syntax highlighting
    bat-extras.batman      # Manual pages with syntax highlighting
    bat-extras.batpipe     # Syntax highlighting for code passed via pipe
    micro                  # Modern and intuitive terminal text editor
    neovim                 # Vim-fork focused on extensibility
    ripgrep                # Fast line-oriented search tool
    ripgrep-all            # Ripgrep but also search in PDFs, Ebooks, etc.

    # =====================================
    # SYSTEM MONITORING
    # =====================================
    btop       # Modern and colorful system monitor
    bottom     # Cross-platform graphical process/system monitor
    htop       # Interactive process viewer (enhanced top)
    glances    # Cross-platform system monitoring tool
    iotop      # Monitor disk I/O usage
    nethogs    # Monitor network traffic per process
    powertop   # Diagnose power consumption issues

    # =====================================
    # BACKUP AND SYNCHRONIZATION
    # =====================================
    borgbackup  # Deduplicating backup program
    rsnapshot   # Filesystem snapshot utility based on rsync
    rsync       # Fast and versatile file copying tool

    # =====================================
    # SHELL AND TERMINAL TOOLS
    # =====================================
    zsh                       # Z shell
    zsh-autosuggestions       # Fish-like autosuggestions for zsh
    zsh-syntax-highlighting   # Fish-like syntax highlighting for zsh
    fzf                       # Command-line fuzzy finder
    starship                  # Cross-shell prompt
    tmux                      # Terminal multiplexer
    tmuxp                     # Tmux session manager
    watch                     # Execute program periodically
    htop                      # system monitoring
    neofetch                  # system info
    unzip                     # p7zip archive tools)
    man-db                    # man-pages documentation

    # =====================================
    # VERSION CONTROL
    # =====================================
    gitFull  # Git with all optional features

    # =====================================
    # MISCELLANEOUS UTILITIES
    # =====================================
    aircrack-ng        # WiFi security auditing tools
    cmatrix            # Terminal matrix animation
    file               # File type detection
    fortune            # Display random quotes
    openssl            # Cryptography and SSL/TLS toolkit
    gtk3               # GUI toolkit
    glib               # Low-level core library
    vaapiVdpau         # VA-API implementation using VDPAU
    libvdpau-va-gl     # VDPAU driver with VA-API support
    mesa               # OpenGL implementation
    util-linux         # System utilities (mount, fdisk, etc.)
    e2fsprogs          # Ext2/3/4 filesystem utilities
    acpi               # Display battery status and thermal information
    lm_sensors         # Hardware monitoring sensors
    taskwarrior3       # Task management system
    tldr               # Simplified man pages
    curl               # Command line tool for transferring data
    curlie             # Curl with sane defaults and syntax highlighting
    jq
    yq-go

    # Nix tools
    nixpkgs-fmt
    nil
    # =====================================
    # SECURITY PACKAGES
    # =====================================
    fail2ban
 ];
in {
  environment.systemPackages = systemPackages;
}
