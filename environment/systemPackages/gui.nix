# GUI applications - desktop environment and graphical tools
{ pkgs, lib, ... }:

with pkgs; [
  # ===== GRAPHICS & GPU STACK =====
  nvidia-vaapi-driver      # NVIDIA VA-API driver
  vulkan-tools             # Vulkan utilities and demos
  vulkan-loader            # Vulkan loader
  mesa-demos               # Mesa OpenGL demos
  libva-utils              # VA-API utilities
  vdpauinfo                # VDPAU capability info
  clinfo                   # OpenCL information
  glmark2                  # OpenGL benchmark
  gpu-viewer               # GPU information viewer
  intel-gpu-tools          # Intel GPU tools
  dxvk                     # DirectX to Vulkan translation
  vkd3d-proton             # Direct3D 12 to Vulkan
  vkbasalt                 # Vulkan post-processing

  # ===== AUDIO STACK =====
  pulsemixer               # CLI PulseAudio mixer
  pavucontrol              # PulseAudio volume control
  alsa-utils               # ALSA sound utilities
  easyeffects              # Audio effects for PipeWire
  carla                    # Audio plugin host
  helvum                   # PipeWire patchbay
  qjackctl                 # JACK audio control
  jack2                    # JACK audio connection kit

  # ===== BROWSERS & COMMUNICATION =====
  brave                    # Brave privacy browser
  google-chrome            # Google Chrome browser
  tor-browser              # Tor anonymity browser
  librewolf                # Privacy-focused Firefox fork
  signal-desktop           # Signal messaging
  telegram-desktop         # Telegram messaging
  thunderbird              # Email client
  discord                  # Gaming communication
  element-desktop          # Matrix client
  slack                    # Team collaboration
  zoom                     # Video conferencing

  # ===== PRODUCTIVITY & OFFICE =====
  libreoffice-fresh        # Office suite
  onlyoffice-desktopeditors # Office suite
  obsidian                 # Note-taking
  logseq                   # Knowledge management
  zotero                   # Reference management
  xournalpp                # Handwritten notes
  freeplane                # Mind mapping
  cherrytree               # Hierarchical note taking
  joplin-desktop           # Note taking
  drawio                   # Diagram creation

  # ===== DEVELOPMENT GUI TOOLS =====
  vscode                   # Visual Studio Code
  dbeaver-bin              # Database administration
  postman                  # API development
  beekeeper-studio         # SQL editor and manager
  sqlitebrowser            # SQLite database browser
  kdePackages.kdevelop     # KDE development environment
  android-studio           # Android development
  arduino-ide              # Arduino development
  helix

  # ===== SYSTEM GUI TOOLS =====
  baobab                   # Disk usage analyzer
  filezilla                # FTP client
  remmina                  # Remote desktop client
  gnome-system-monitor     # System monitor

  # ===== SECURITY GUI =====
  bitwarden-desktop        # Password manager
  keepassxc                # Password manager
  veracrypt                # Disk encryption

  # ===== SCIENTIFIC & EDUCATION =====
  qgis                     # Geographic information system
  rstudio                  # R development environment
  anki                     # Flashcard learning
  geogebra                 # Mathematics software

  # ===== KDE SPECIFIC APPLICATIONS =====
  kdePackages.okular       # Document viewer
  kdePackages.dolphin      # File manager
  kdePackages.konsole      # Terminal emulator
  kdePackages.kmail        # Email client
  kdePackages.kontact      # Personal information manager
  kdePackages.korganizer   # Calendar and scheduling
  kdePackages.ark          # Archiving tool
  kdePackages.filelight    # Disk usage visualization
  kdePackages.sweeper      # System cleaning

  # ===== QT6 PACKAGES FOR PLASMA 6 =====
  qt6.qtbase               # Qt6 base libraries
  qt6.qtdeclarative        # Qt6 QML and Quick
  qt6.qttools              # Qt6 tools
  qt6.qtwayland            # Qt6 Wayland support
  qt6.qtmultimedia         # Qt6 multimedia
  qt6.qtsvg                # Qt6 SVG support
  qt6.qtwebengine          # Qt6 WebEngine

  # ===== HARDWARE SUPPORT =====
  libratbag                # Gaming mouse configuration
  piper                    # GUI for libratbag

  # ===== MEDIA VIEWERS =====
  feh                      # Image viewer
  sxiv                     # Simple image viewer
  imv                      # Image viewer

  # ===== THEMES & APPEARANCE =====
  catppuccin-gtk           # Catppuccin theme for GTK
  tela-circle-icon-theme   # Tela circle icons
  papirus-icon-theme       # Papirus icon theme
]
