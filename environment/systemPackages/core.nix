{ pkgs, lib, ... }:

with pkgs; [
  # ===== SYSTEM ABSOLUTES =====
  sudo                    # Superuser permissions
  polkit                  # PolicyKit authorization
  dbus                    # Inter-process communication
  networkmanager          # Network connection manager
  openssh                 # Secure shell access
  avahi                   # Zero-configuration networking
  cups                    # Printing system

  # ===== CORE UNIX =====
  coreutils               # Complete GNU core utilities (brug coreutils i stedet for coreutils-full)
  util-linux              # System utilities (mount, fdisk, etc.)
  findutils               # find, xargs, locate
  diffutils               # diff, cmp, patch
  gnused                  # GNU stream editor
  gnugrep                 # GNU pattern matching
  gawk                    # GNU awk text processing
  gnutar                  # Tape archiver
  gzip                    # Compression utility
  bzip2                   # Block-sorting compressor
  xz                      # LZMA compression
  zstd                    # Zstandard compression
  file                    # File type detection
  which                   # Command locator
  # whereis               # Locate command binaries - FJERNET (er tilgængelig)
  time                    # Command execution timer
  bc                      # Arbitrary precision calculator
  dc                      # Desk calculator
  patch                   # Apply diff files
  less                    # Better file pager
  moreutils               # Additional Unix utilities
  pv                      # Pipe viewer
  progress                # Coreutils progress viewer

  # ===== HARDWARE INFORMATION =====
  pciutils                # PCI bus utilities (lspci)
  usbutils                # USB utilities (lsusb)
  lm_sensors              # Hardware monitoring sensors
  efibootmgr              # UEFI boot manager
  dmidecode               # DMI table decoder
  lshw                    # Hardware lister
  lsof                    # List open files
  psmisc                  # Process utilities (killall, pstree)
  hwdata                  # Hardware database
  edid-decode             # Monitor EDID information
  # biosdevname             # Network device naming - FJERNET (ikke tilgængelig)
  ethtool                 # Ethernet device settings
  iw                      # Wireless device configuration

  # ===== ARCHIVING & COMPRESSION =====
  p7zip                   # 7-zip file archiver
  unzip                   # ZIP archive extractor
  zip                     # ZIP archive creator
  unrar                   # RAR archive extractor
  lz4                     # LZ4 compression
  lzop                    # LZO compression
  brotli                  # Brotli compression

  # ===== SECURITY & CRYPTO =====
  openssl                 # Cryptography and SSL/TLS toolkit
  libnotify               # Desktop notifications
  gnupg                   # GNU Privacy Guard
  pinentry                # PIN entry dialog
  pass                    # Password store
  age                     # Simple, modern encryption
  sops                    # Secrets management
  libfido2                # FIDO2 support
  yubikey-manager         # YubiKey management
  oath-toolkit            # OATH one-time passwords

  # ===== SHELL & TERMINAL =====
  zoxide                  # Smart directory jumping
  starship                # Cross-shell prompt
  oh-my-posh              # Prompt theme engine
  fish                    # Friendly interactive shell
  zsh                     # Z shell
  tmux                    # Terminal multiplexer
  tmuxp                   # Tmux session manager
  screen                  # GNU screen multiplexer
  expect                  # Automated terminal interaction

  # ===== NIX ECOSYSTEM =====
  home-manager            # User environment management
  nix-index               # File database for nix-locate
  # nix-search              # Search nix packages - FJERNET (ikke tilgængelig)
  nixd                    # Nix language server
  nix-tree                # Browse nix dependency trees
  nix-diff                # Compare nix derivations
  nix-output-monitor      # Enhanced nix-build output
  nix-du                  # Analyze nix store usage
  nixos-option            # Inspect NixOS configuration options
  comma                   # Run temporarily installed programs
  nixpkgs-fmt             # Nix code formatter
  # nixfmt-classic          # Alternative nix formatter - FJERNET (ikke tilgængelig)
  statix                  # Lints and suggestions for Nix code
  alejandra               # Fast nix code formatter
  manix                   # Nix documentation search
  cachix                  # Nix binary cache service
  direnv                  # Environment variable management
  nixos-generators        # Generate ISOs from configurations
  nh                      # Nix helper wrapper
  nil                     # Nix language server
  nix-prefetch            # Prefetch nix sources
  nix-update              # Update nix packages
  # nixos-shell             # NixOS in a shell - FJERNET (ikke tilgængelig)
  # nix-bundle              # Bundle nix applications - FJERNET (ikke tilgængelig)
  # nixos-rebuild           # Rebuild system - FJERNET (allerede i system)

  # ===== NETWORK TOOLS =====
  inetutils               # Classic network tools (telnet, ftp)
  iproute2                # Modern IP routing utilities
  iputils                 # Network testing tools (ping, traceroute)
  curl                    # URL transfer tool
  wget                    # Web content downloader
  # wget2                   # Modern wget - FJERNET (ikke tilgængelig)
  aria2                   # Download utility
  netcat-openbsd          # Network Swiss army knife
  socat                   # Multipurpose relay
  # openssh                 # SSH client and server - ALLEREDE TILFØJET
  sshfs                   # SSH filesystem
  sshpass                 # SSH password authentication
  rsync                   # File synchronization
  rclone                  # Cloud storage sync

  # ===== DOCUMENTATION =====
  man-db                  # Manual page system
  man-pages               # Linux manual pages
  texinfo                 # Documentation system
  info                    # GNU info reader
]
