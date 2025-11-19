{ pkgs, lib, ... }:


with pkgs; [
  # Modern CLI tools
  eza
  bat
  bat-extras.batdiff
  bat-extras.batman
  bat-extras.batpipe
  fd
  ripgrep
  ripgrep-all
  fzf
  bottom
  dust
  procs
  sd
  choose
  fselect
  tree
  broot
  watch

  # Git - ALL git tools!
  gitFull
  git-extras
  delta
  lazygit
  github-cli
  git-crypt
  git-open
  git-revise
  gitui
  gitflow
  tig

  # File management - ALL file managers!
  ranger
  nnn
  fff
  mc
  lf

  # Network tools - EVERYTHING!
  networkmanagerapplet
  wireshark
  nmap
  masscan
  iperf3
  traceroute
  mtr
  ipcalc
  iftop
  bmon
  netcat-openbsd
  socat
  tcpdump
  tcpflow
  httpie
  sshpass
  sshfs
  whois
  macchanger
  openvpn
  tailscale
  wireguard-tools
  inetutils
  bind
  openssh

  # Security - ALL security tools!
  age
  sops
  aircrack-ng
  ettercap
  firejail

  # System monitoring - EVERY monitoring tool!
  neofetch
  onefetch
  fastfetch
  gotop
  btop
  htop
  iotop
  nethogs
  bandwhich
  zenith
  dool
  mission-center
  glances
  netdata

  # Information & documentation
  tldr
  cheat
  taskwarrior2

  # Fun & entertainment - ALL FUN STUFF!
  cowsay
  fortune
  sl
  asciiquarium
  cbonsai
  cmatrix
  figlet
  speedtest-cli
  fast-cli
  termscp
  cava
  pipes-rs
  lolcat
]
