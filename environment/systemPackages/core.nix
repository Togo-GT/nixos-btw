{ pkgs, lib, ... }:

with pkgs; [
  # ===== ABSOLUTELY ESSENTIAL SYSTEM =====
  sudo                    # Superuser permissions management
  polkit                  # PolicyKit for privilege escalation
  dbus                    # Message bus system
  networkmanager          # Network connection management
  openssh                 # SSH server and client

  # ===== CORE UNIX UTILITIES =====
  coreutils-full          # Complete GNU core utilities (ls, cp, mv, etc.)
  findutils               # find, locate, xargs
  gnused                  # GNU stream editor
  gnugrep                 # GNU grep pattern matching
  gawk                    # GNU awk text processing
  diffutils               # diff, cmp utilities
  which                   # Locate command in PATH
  time                    # Time command execution
  bc                      # Arbitrary precision calculator
  patch                   # Apply patch files
  less                    # Better file pager
  moreutils               # Additional Unix utilities

  # ===== SYSTEM INFORMATION TOOLS =====
  vim                     # Vi Improved text editor
  neovim                  # Modern Vim fork
  wget                    # Web content downloader
  curl                    # URL transfer tool
  file                    # File type detection
  pciutils                # PCI bus utilities (lspci)
  usbutils                # USB utilities (lsusb)
  lm_sensors              # Hardware monitoring sensors
  efibootmgr              # UEFI boot manager
  dmidecode               # DMI table decoder
  lshw                    # Hardware lister
  lsof                    # List open files
  psmisc                  # Process utilities (killall, pstree)
  p7zip                   # 7-zip file archiver
  unzip                   # ZIP archive extractor
  zip                     # ZIP archive creator
  openssl                 # Cryptography and SSL/TLS toolkit
  libnotify               # Desktop notifications

  # ===== SHELL & TERMINAL ENHANCEMENTS =====
  zoxide                  # Smart directory jumping
  starship                # Cross-shell prompt
  oh-my-posh              # Prompt theme engine
  fish                    # Friendly interactive shell
  zsh                     # Z shell
  tmux                    # Terminal multiplexer
  tmuxp                   # Tmux session manager

  # ===== NIX PACKAGE MANAGEMENT =====
  home-manager            # User environment management
  nix-index               # File database for nix-locate
  nix-search              # Search nix packages
  nixd                    # Nix language server
  nix-tree                # Browse nix dependency trees
  nix-diff                # Compare nix derivations
  nix-output-monitor      # Enhanced nix-build output
  nix-du                  # Analyze nix store usage
  nixos-option            # Inspect NixOS configuration options
  comma                   # Run temporarily installed programs
  nixpkgs-fmt             # Nix code formatter
  nixfmt-classic          # Alternative nix formatter
  statix                  # Lints and suggestions for Nix code
  alejandra               # Fast nix code formatter
  manix                   # Nix documentation search
  cachix                  # Nix binary cache service
  direnv                  # Environment variable management
  nixos-generators        # Generate ISOs from configurations
  nh                      # Nix helper wrapper
  nil                     # Nix language server

  # ===== ESSENTIAL DEVELOPMENT =====
  git                     # Distributed version control system
  gnupg                   # GNU Privacy Guard encryption
  pinentry-gnome3         # PIN entry dialog for GnuPG
  pinentry-curses         # PIN entry dialog for GnuPG

  # ===== NETWORK DIAGNOSTICS =====
  inetutils               # Classic network tools (telnet, ftp)
  iproute2                # Modern IP routing utilities (ip command)
  iputils                 # Network testing tools (ping, traceroute)

  # ===== SECURITY TOOLS =====
  pass                    # Password store
  age                     # Simple, modern encryption
  sops                    # Secrets management

  # ===== DOCUMENTATION =====
  man-db                  # Manual page system
  man-pages               # Linux manual pages
  texinfo                 # Documentation system
]
