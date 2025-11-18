{ pkgs }:

with pkgs; [
  # ABSOLUTELY ESSENTIAL SYSTEM
  sudo
  polkit
  dbus
  networkmanager
  openssh

  # Core utilities
  vim
  neovim
  wget
  curl
  file
  pciutils
  usbutils
  lm_sensors
  efibootmgr
  dmidecode
  lshw
  lsof
  psmisc
  p7zip
  unzip
  zip
  openssl
  libnotify

  # Shell & terminal
  zoxide
  starship
  oh-my-posh
  fish
  zsh
  tmux
  tmuxp

  # Package management (Nix) - ALL OF THEM!
  home-manager
  nix-index
  nix-search
  nixd
  nix-tree
  nix-diff
  nix-output-monitor
  nix-du
  nixos-option
  comma
  nixpkgs-fmt
  nixfmt-classic
  statix
  alejandra
  manix
  cachix
  direnv
  nixos-generators
  nh
  nil
]
