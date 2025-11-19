{ pkgs, lib, ... }:

with pkgs; [
  # ===== MODERN CLI REPLACEMENTS =====
  eza                       # Modern ls replacement
  bat                       # Cat clone with syntax highlighting
  bat-extras.batdiff        # Git diff with bat
  bat-extras.batman         # Manual pages with bat
  # bat-extras.batgrep        # Grep with bat - FJERNET (ikke tilgængelig)
  # bat-extras.batwatch       # Watch with bat - FJERNET (ikke tilgængelig)
  fd                        # Fast find replacement
  ripgrep                   # Fast grep replacement
  # ripgrep-all               # Ripgrep for all file types - FJERNET (ikke tilgængelig)
  fzf                       # Fuzzy finder
  # fzf-zsh                   # Zsh fzf integration - FJERNET (ikke tilgængelig)
  # fzf-fish                  # Fish fzf integration - FJERNET (ikke tilgængelig)
  bottom                    # System monitor (htop alternative)
  dust                      # More intuitive du
  procs                     # Modern ps replacement
  sd                        # Intuitive find and replace
  choose                    # Better cut command
  # fselect                   # Find files with SQL-like queries - FJERNET (ikke tilgængelig)
  # xsv                       # CSV toolkit
  tree                      # Directory listing as tree
  broot                     # Terminal file manager
  zellij                    # Terminal workspace
  watch                     # Execute program periodically
  entr                      # Run commands when files change
  parallel                  # Parallel execution
  # pexec                     # Parameterized execution - FJERNET (ikke tilgængelig)
  prettyping                # Ping with graph
  mtr                       # Network diagnostic tool

  # ===== GIT TOOLS =====
  git                       # Distributed version control (brug git i stedet for gitFull)
  git-lfs                   # Git large file storage
  git-extras                # Additional git commands
  delta                     # Syntax-highlighting pager for git
  lazygit                   # Terminal UI for git
  github-cli                # Official GitHub CLI
  git-crypt                 # Git file encryption
  git-open                  # Open repo website from terminal
  # git-revise                # Git commit editing - FJERNET (ikke tilgængelig)
  gitui                     # Terminal git client
  gitflow                   # Git branching model
  tig                       # Text-mode interface for git
  # git-standup               # Git commit summary - FJERNET (ikke tilgængelig)
  # git-interactive-rebase-tool # Interactive rebase tool - FJERNET (ikke tilgængelig)
  # git-bug                   # Distributed bug tracker - FJERNET (ikke tilgængelig)

  # ===== FILE MANAGEMENT =====
  ranger                    # Terminal file manager with vi keys
  nnn                       # Tiny terminal file manager
  # fff                       # Simple file manager - FJERNET (ikke tilgængelig)
  mc                        # Midnight Commander file manager
  lf                        # Terminal file manager
  vifm                      # Vim-like file manager
  # clifm                     # Command line file manager - FJERNET (ikke tilgængelig)
  xplr                      # Hackable file manager

  # ===== NETWORK TOOLS =====
  networkmanagerapplet      # NetworkManager tray applet
  wireshark                 # Network protocol analyzer
  wireshark-cli             # Wireshark command line tools
  nmap                      # Network discovery and security
  # masscan                   # Mass IP port scanner - FJERNET (ikke tilgængelig)
  iperf3                    # Network performance testing
  traceroute                # Trace network route
  # mtr                       # Network diagnostic tool - ALLEREDE TILFØJET
  ipcalc                    # IP address calculator
  iftop                     # Network bandwidth monitoring
  bmon                      # Bandwidth monitor
  netcat-openbsd            # Network Swiss army knife
  socat                     # Multipurpose relay tool
  tcpdump                   # Network packet analyzer
  # tcpflow                   # TCP flow recorder - FJERNET (ikke tilgængelig)
  ngrep                     # Network grep
  dnsutils                  # DNS utilities (dig, nslookup)
  # ldns                      # Modern DNS library and tools - FJERNET (ikke tilgængelig)
  dog                       # Modern DNS lookup client
  # drill                     # DNS debugging tool - FJERNET (ikke tilgængelig)
  httpie                    # User-friendly HTTP client
  curlie                    # Frontend to curl
  xh                        # Friendly and fast HTTP client
  websocat                  # WebSocket client
  # wuzz                      # Interactive HTTP inspector - FJERNET (ikke tilgængelig)
  sshpass                   # SSH password authentication
  sshfs                     # SSH filesystem
  # rssh                      # Restricted SSH - FJERNET (ikke tilgængelig)
  whois                     # Domain information lookup
  macchanger                # MAC address changer
  openvpn                   # VPN solution
  tailscale                 # Mesh VPN
  wireguard-tools           # WireGuard VPN tools
  inetutils                 # Classic network tools
  bind                      # DNS server utilities
  openssh                   # SSH client and server
  autossh                   # Automatically restart SSH sessions
  mosh                      # Mobile shell
  termshark                 # Terminal-based Wireshark
  speedtest-cli             # Internet speed test
  # fast-cli                  # Fast.com speed test - FJERNET (ikke tilgængelig)
  iw                        # Wireless configuration
  aircrack-ng               # WiFi security auditing
  # reaver                    # WPS attack tool - FJERNET (ikke tilgængelig)
  # bully                     # WPS brute force - FJERNET (ikke tilgængelig)
  # pixiewps                  # WPS offline brute force - FJERNET (ikke tilgængelig)

  # ===== SECURITY TOOLS =====
  age                       # Simple, modern encryption
  sops                      # Secrets management
  # aircrack-ng               # WiFi security auditing - ALLEREDE TILFØJET
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
  # burpsuite                 # Web security testing - FJERNET (ikke tilgængelig)
  sqlmap                    # SQL injection tool
  nikto                     # Web server scanner
  wfuzz                     # Web fuzzer
  ffuf                      # Fast web fuzzer
  amass                     # Network reconnaissance
  subfinder                 # Subdomain discovery
  naabu                     # Port scanning
  httpx                     # HTTP toolkit
  nuclei                    # Vulnerability scanner
  # metasploit                # Penetration testing - FJERNET (ikke tilgængelig)
  john                      # Password cracker
  hashcat                   # Advanced password recovery
  hydra                     # Login cracker
  patator                   # Multi-purpose brute-forcer
  # crowbar                   # Brute forcing tool - FJERNET (ikke tilgængelig)
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
  # mission-center            # System monitoring center - FJERNET (ikke tilgængelig)
  glances                   # Cross-platform system monitor
  netdata                   # Real-time performance monitoring
  # prometheus                # Monitoring system - FJERNET (ikke tilgængelig)
  # grafana                   # Analytics and monitoring - FJERNET (ikke tilgængelig)
  # node_exporter             # Hardware and OS metrics - FJERNET (ikke tilgængelig)
  # cadvisor                  # Container monitoring - FJERNET (ikke tilgængelig)

  # ===== INFORMATION & DOCUMENTATION =====
  tldr                      # Simplified man pages
  tealdeer                  # Rust implementation of tldr
  cheat                     # Create and view cheatsheets
  navi                      # Interactive cheatsheets
  taskwarrior               # Task management
  # taskwarrior-tui           # Taskwarrior TUI - FJERNET (ikke tilgængelig)
  timewarrior               # Time tracking
  khal                      # Calendar
  vdirsyncer                # Calendar and contacts sync

  # ===== FILE UTILITIES =====
  rsync                     # Fast file transfer
  rclone                    # Cloud storage sync
  restic                    # Backup program
  borgbackup                # Deduplicating backup
  duplicity                 # Encrypted backup
  unison                    # File synchronization
  # fpart                     # File partitioner - FJERNET (ikke tilgængelig)
  fdupes                    # Duplicate file finder
  rmlint                    # Remove duplicates and other lint
  jdupes                    # Duplicate file finder
  fclones                   # Fast duplicate file finder
  rmtrash                   # Safe file removal
  trash-cli                 # Command line trash can
  atool                     # Archive manager
  archivemount              # FUSE based archive mounter
  # sshfs                     # SSH filesystem - ALLEREDE TILFØJET
  curlftpfs                 # FTP filesystem
  fuseiso                   # ISO mount
]
