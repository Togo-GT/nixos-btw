{ pkgs, lib, ... }:

with pkgs; [
  # ===== MODERN CLI REPLACEMENTS =====
  eza                       # Modern ls replacement
  bat                       # Cat clone with syntax highlighting
  bat-extras.batdiff        # Git diff with bat
  bat-extras.batman         # Manual pages with bat
  bat-extras.batpipe        # File preview in pipes
  fd                        # Fast find replacement
  ripgrep                   # Fast grep replacement
  ripgrep-all               # Ripgrep for all file types
  fzf                       # Fuzzy finder
  bottom                    # System monitor (htop alternative)
  dust                      # |* More intuitive du *|
  procs                     # Modern ps replacement
  sd                        # Intuitive find and replace
  choose                    # Better cut command
  fselect                   # Find files with SQL-like queries
  tree                      # Directory listing as tree
  broot                     # Terminal file manager
  watch                     # Execute program periodically

  # ===== GIT TOOLS =====
  gitFull                   # Git with all features
  git-extras                # Additional git commands
  delta                     # Syntax-highlighting pager for git
  lazygit                   # |* Terminal UI for git *|
  github-cli                # Official GitHub CLI
  git-crypt                 # Git file encryption
  git-open                  # Open repo website from terminal
  git-revise                # Git commit editing
  gitui                     # Terminal git client
  gitflow                   # Git branching model
  tig                       # Text-mode interface for git

  # ===== FILE MANAGEMENT =====
  ranger                    # |* Terminal file manager with vi keys *|
  nnn                       # Tiny terminal file manager
  fff                       # Simple file manager
  mc                        # Midnight Commander file manager
  lf                        # Terminal file manager

  # ===== NETWORK TOOLS =====
  networkmanagerapplet      # NetworkManager tray applet
  wireshark                 # Network protocol analyzer
  nmap                      # Network discovery and security
  masscan                   # Mass IP port scanner
  iperf3                    # Network performance testing
  traceroute                # Trace network route
  mtr                       # Network diagnostic tool
  ipcalc                    # IP address calculator
  iftop                     # Network bandwidth monitoring
  bmon                      # |* Bandwidth monitor *|
  netcat-openbsd            # Network Swiss army knife
  socat                     # Multipurpose relay tool
  tcpdump                   # Network packet analyzer
  tcpflow                   # TCP flow recorder
  httpie                    # User-friendly HTTP client
  sshpass                   # SSH password authentication
  sshfs                     # SSH filesystem
  whois                     # Domain information lookup
  macchanger                # MAC address changer
  openvpn                   # VPN solution
  tailscale                 # Mesh VPN
  wireguard-tools           # WireGuard VPN tools
  inetutils                 # Classic network tools
  bind                      # DNS server utilities
  openssh                   # SSH client and server

  # ===== MODERN NETWORK TOOLS =====
  dog                       # Modern DNS lookup client
  xh                        # Friendly and fast HTTP client
  netdiscover               # Network address discovery
  arp-scan                  # ARP packet scanner
  ngrep                     # Network grep
  termshark                 # |* Terminal-based Wireshark *|

  # ===== SECURITY TOOLS =====
  age                       # Simple, modern encryption
  sops                      # Secrets management
  aircrack-ng               # |* WiFi security auditing *|
  ettercap                  # Network security tool
  firejail                  # Sandboxing tool
  gitleaks                  # Git secrets scanner
  trufflehog                # Find exposed credentials
  binwalk                   # |* Firmware analysis tool *|
  foremost                  # File recovery
  scalpel                   # File carving

  # ===== SYSTEM MONITORING =====
  neofetch                  # System information
  onefetch                  # Git repository summary
  fastfetch                 # Fast system information
  gotop                     # |* Terminal-based system monitor *|
  btop                      # |* Resource monitor *|
  htop                      # |* Interactive process viewer *|
  iotop                     # I/O monitoring
  nethogs                   # Per-process network traffic
  bandwhich                 # Terminal bandwidth utilization
  zenith                    # System monitor with charts
  dool                      # Resource statistics tool
  mission-center            # System monitoring center
  glances                   # |* Cross-platform system monitor *|
  netdata                   # Real-time performance monitoring

  # ===== INFORMATION & DOCUMENTATION =====
  tldr                      # Simplified man pages
  tealdeer                  # Rust implementation of tldr
  cheat                     # Create and view cheatsheets
  navi                      # Interactive cheatsheets
  taskwarrior2              # Task management

  # ===== FILE UTILITIES =====
  rsync                     # Fast file transfer
  rclone                    # Cloud storage sync
  restic                    # Backup program
  entr                      # Run commands when files change
  pastel                    # Color manipulation tool
  vivid                     # LS_COLORS theme generator

  # ===== PRODUCTIVITY TOOLS =====
  just                      # Command runner
  cheat                     # Cheat sheets for commands

  # ===== FUN & ENTERTAINMENT =====
  cowsay                    # ASCII art cow with messages
  fortune                   # Random quotes
  sl                        # Steam locomotive for mistyped 'ls'
  asciiquarium              # Terminal aquarium
  cbonsai                   # Bonsai tree generator
  cmatrix                   # Matrix-style screen
  figlet                    # ASCII banner generator
  speedtest-cli             # Internet speed test
  fast-cli                  # Fast.com speed test
  termscp                   # Terminal file exchange
  cava                      # Audio visualizer
  pipes-rs                  # Animated pipes
  lolcat                    # Rainbow text generator
]
