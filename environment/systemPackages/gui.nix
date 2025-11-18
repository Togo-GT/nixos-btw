{ pkgs }:

with pkgs; [
  # Graphics & GPU - COMPLETE graphics stack
  nvidia-vaapi-driver
  nvitop
  vulkan-tools
  vulkan-loader
  mesa-demos
  libva-utils
  vdpauinfo
  clinfo
  glmark2
  gpu-viewer
  intel-gpu-tools
  dxvk
  vkd3d-proton
  vkbasalt

  # Audio - COMPLETE audio stack
  pulsemixer
  pavucontrol
  alsa-utils
  easyeffects
  carla
  helvum
  qjackctl
  jack2

  # Browsers & Communication - ALL browsers!
  chromium
  firefox
  brave
  signal-desktop
  telegram-desktop
  thunderbird
  discord
  element-desktop
  slack
  zoom

  # Productivity - EVERY office app!
  libreoffice-fresh
  onlyoffice-desktopeditors
  obsidian
  zotero
  xournalpp
  masterpdfeditor
  freeplane
  cherrytree
  joplin-desktop
  typora
  marktext

  # Development GUI - ALL IDEs and tools!
  vscode
  zed-editor
  dbeaver-bin
  postman
  beekeeper-studio
  sqlitebrowser
  lens
  kdePackages.kdevelop

  # System GUI tools
  baobab
  filezilla
  remmina
  gnome-system-monitor

  # Security GUI
  bitwarden-desktop
  keepassxc
  totp-cli
  veracrypt

  # Scientific
  qgis
  rstudio
  anki
  geogebra

  # KDE Specific - COMPLETE KDE suite
  kdePackages.okular
  kdePackages.dolphin
  kdePackages.konsole
  kdePackages.kmail
  kdePackages.kontact
  kdePackages.korganizer
  kdePackages.ark
  kdePackages.filelight
  kdePackages.sweeper

  # Qt6 packages for Plasma 6
  qt6.qtbase
  qt6.qtdeclarative
  qt6.qttools
  qt6.qtwayland
  qt6.qtmultimedia
  qt6.qtsvg
  qt6.qtwebengine

  # Hardware support
  libratbag
  piper

  # Themes & appearance
  catppuccin-kde
  catppuccin-gtk
  tela-circle-icon-theme
  papirus-icon-theme
]
