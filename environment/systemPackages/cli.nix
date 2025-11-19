# CLI utilities - modern command line tools and replacements
{ pkgs, lib, ... }:

with pkgs; [
  # ===== MODERN CLI REPLACEMENTS =====
  eza                       # Modern ls replacement
  bat                       # Cat clone with syntax highlighting
  bat-extras.batdiff        # Git diff with bat
  bat-extras.batman         # Manual pages with bat
  fd                        # Fast find replacement
  ripgrep                   # Fast grep replacement
  fzf                       # Fuzzy finder
  bottom                    # System monitor (htop alternative)
  dust                      # More intuitive du
  procs                     # Modern ps replacement
  sd                        # Intuitive find and replace
  choose                    # Better cut command
  tree                      # Directory listing as tree
  broot                     # Terminal file manager
  zellij                    # Terminal workspace
  watch                     # Execute program periodically
  entr                      # Run commands when files change
  parallel                  # Parallel execution
  prettyping                # Ping with graph
  mtr                       # Network diagnostic tool

  # ===== GIT TOOLS =====
  git                       # Distributed version control
  git-lfs                   # Git large file storage
  git-extras                # Additional git commands
  delta                     # Syntax-highlighting pager for git
  lazygit                   # Terminal UI for git
  github-cli                # Official GitHub CLI
  git-crypt                 # Git file encryption
  git-open                  # Open repo website from terminal
  gitui                     # Terminal git client
  gitflow                   # Git branching model
  tig                       # Text-mode interface for git

  # ===== FILE MANAGEMENT =====
  ranger                    # Terminal file manager with vi keys
  nnn                       # Tiny terminal file manager
  mc                        # Midnight Commander file manager
  lf                        # Terminal file manager
  vifm                      # Vim-like file manager
  xplr                      # Hackable file manager

  # ===== NETWORK TOOLS =====
  networkmanagerapplet      # NetworkManager tray applet
  wireshark                 # Network protocol analyzer
  wireshark-cli             # Wireshark command line tools
  nmap                      # Network discovery and security
  iperf3                    # Network performance testing
  traceroute                # Trace network route
  ipcalc                    # IP address calculator
  iftop                     # Network bandwidth monitoring
  bmon                      # Bandwidth monitor
  tcpdump                   # Network packet analyzer
  ngrep                     # Network grep
  dnsutils                  # DNS utilities (dig, nslookup)
  dog                       # Modern DNS lookup client
  httpie                    # User-friendly HTTP client
  curlie                    # Frontend to curl
  xh                        # Friendly and fast HTTP client
  websocat                  # WebSocket client
  whois                     # Domain information lookup
  macchanger                # MAC address changer
  openvpn                   # VPN solution
  tailscale                 # Mesh VPN
  wireguard-tools           # WireGuard VPN tools
  bind                      # DNS server utilities
  autossh                   # Automatically restart SSH sessions
  mosh                      # Mobile shell
  termshark                 # Terminal-based Wireshark
  speedtest-cli             # Internet speed test
  aircrack-ng               # WiFi security auditing

  # ===== SECURITY TOOLS =====
  ettercap                  # Network security tool
  firejail                  # Sandboxing tool
  gitleaks                  # Git secrets scanner
  trufflehog                # Find exposed credentials
  binwalk                   # Firmware analysis tool
  foremost                  # File recovery
  scalpel                   # File carving
  steghide                  # Steganography
  exiftool                  # Metadata viewer
  pdf-parser                # PDF analysis
  yara                      # Malware identification
  radare2                   # Reverse engineering
  ghidra                    # Software reverse engineering
  sqlmap                    # SQL injection tool
  nikto                     # Web server scanner
  wfuzz                     # Web fuzzer
  ffuf                      # Fast web fuzzer
  amass                     # Network reconnaissance
  subfinder                 # Subdomain discovery
  naabu                     # Port scanning
  httpx                     # HTTP toolkit
  nuclei                    # Vulnerability scanner
  john                      # Password cracker
  hashcat                   # Advanced password recovery
  hydra                     # Login cracker
  lynis                     # Security auditing tool

  # ===== SYSTEM MONITORING =====
  neofetch                  # System information
  onefetch                  # Git repository summary
  fastfetch                 # Fast system information
  gotop                     # Terminal-based system monitor
  btop                      # Resource monitor
  htop                      # Interactive process viewer
  iotop                     # I/O monitoring
  nethogs                   # Per-process network traffic
  bandwhich                 # Terminal bandwidth utilization
  zenith                    # System monitor with charts
  dool                      # Resource statistics tool
  glances                   # Cross-platform system monitor
  netdata                   # Real-time performance monitoring

  # ===== INFORMATION & DOCUMENTATION =====
  tldr                      # Simplified man pages
  tealdeer                  # Rust implementation of tldr
  cheat                     # Create and view cheatsheets
  navi                      # Interactive cheatsheets
  taskwarrior               # Task management
  timewarrior               # Time tracking
  khal                      # Calendar
  vdirsyncer                # Calendar and contacts sync

  # ===== FILE UTILITIES =====
  restic                    # Backup program
  unison                    # File synchronization
  fdupes                    # Duplicate file finder
  rmlint                    # Remove duplicates and other lint
  jdupes                    # Duplicate file finder
  fclones                   # Fast duplicate file finder
  rmtrash                   # Safe file removal
  trash-cli                 # Command line trash can
  atool                     # Archive manager
  archivemount              # FUSE based archive mounter
  curlftpfs                 # FTP filesystem
  fuseiso                   # ISO mount
]
