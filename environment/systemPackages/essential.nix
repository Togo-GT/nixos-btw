# essential
# environment/systemPackages/essential.nix
{ pkgs, lib, ... }:

with pkgs; [
  # ===== SYSTEM ABSOLUTES =====
  sudo
  polkit
  dbus
  networkmanager
  openssh
  avahi
  cups

  # ===== CORE UNIX UTILITIES =====
  coreutils
  util-linux
  findutils
  diffutils
  gnused
  gnugrep
  gawk
  gnutar
  gzip
  bzip2
  xz
  zstd
  file
  which
  time
  less

  # ===== HARDWARE INFORMATION =====
  pciutils
  usbutils
  lm_sensors
  efibootmgr
  dmidecode

  # ===== ARCHIVING & COMPRESSION =====
  p7zip
  unzip
  zip
  unrar

  # ===== SECURITY & CRYPTO =====
  openssl
  gnupg
  pinentry-curses

  # ===== SHELL & TERMINAL =====
  zsh
  tmux
  fish

  # ===== NIX ECOSYSTEM (CRITICAL) =====
  home-manager
  nix-index
  nixos-option
  direnv
  cachix

  # ===== NETWORK TOOLS (ESSENTIAL) =====
  iproute2
  iputils
  curl
  wget
  netcat-openbsd
  rsync

  # ===== SYSTEM MONITORING =====
  htop
  iotop
  nethogs

  # ===== TEXT EDITORS =====
  neovim
  vim

  # ===== VERSION CONTROL =====
  git
  git-lfs

  # ===== MODERN CLI REPLACEMENTS (CORE) =====
  eza
  bat
  fd
  ripgrep
  fzf

  # ===== DOCUMENTATION =====
  man-db
  man-pages
  texinfo

  # ===== DEVELOPMENT (CORE ONLY) =====
  gcc
  gnumake
  python3
  nodejs
  jdk21
  rustup

  # ===== SYSTEM ADMINISTRATION =====
  strace
  ltrace
  perf-tools
  sysstat
  smartmontools
  ncdu

  # ===== MEDIA (MINIMAL) =====
  ffmpeg
  mpv
  imagemagick

  # ===== GRAPHICS (ESSENTIAL) =====
  gimp
  inkscape

  # ===== BROWSERS =====
  firefox
  chromium

  # ===== FILE MANAGEMENT =====
  gnome-disk-utility
  gparted
  file-roller

  # ===== SECURITY TOOLS =====
  bitwarden-desktop
  keepassxc

  # ===== VIRTUALIZATION (CORE) =====
  virt-manager
  qemu

  # ===== GAMING (FOUNDATION) =====
  steam
  wine
  winetricks
  gamemode
]
