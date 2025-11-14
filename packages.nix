# packages.nix - UPDATED VERSION WITH NEW GUI PACKAGES
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ========================
    # CORE SYSTEM TOOLS
    # ========================
    vim
    neovim
    micro
    wget
    curl
    curlie
    file
    pciutils
    usbutils
    lm_sensors
    inxi
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

    # ========================
    # PACKAGE MANAGEMENT (NIX)
    # ========================
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

    # ========================
    # SHELL & TERMINAL
    # ========================
    zoxide
    starship
    oh-my-posh
    fish
    zsh
    tmux
    tmuxp

    # ========================
    # HARDWARE INFORMATION
    # ========================
    hwloc
    powertop
    acpi
    cpupower-gui
    powerstat
    smartmontools
    s-tui
    stress-ng

    # ========================
    # STORAGE & FILESYSTEMS
    # ========================
    gnome-disk-utility
    gparted
    parted
    hdparm
    ncdu
    duf
    agedu
    rsync
    btrfs-progs
    xfsprogs
    e2fsprogs
    mdadm
    lvm2
    cryptsetup
    nvme-cli
    util-linux
    testdisk
    gsmartcontrol
    ntfs3g
    borgbackup
    rsnapshot

    # ========================
    # GRAPHICS & GPU
    # ========================
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

    # ========================
    # AUDIO
    # ========================
    pulsemixer
    pavucontrol
    alsa-utils
    easyeffects
    carla
    helvum
    qjackctl
    jack2

    # ========================
    # DEVELOPMENT TOOLS
    # ========================
    gcc
    gnumake
    pkg-config
    cmake
    gdb
    strace
    ltrace
    valgrind
    shellcheck
    hadolint

    # ========================
    # PROGRAMMING LANGUAGES
    # ========================
    python3
    python3Packages.pip
    pipx
    go
    nodejs
    perl
    rustup

    # ========================
    # DEVELOPMENT UTILITIES
    # ========================
    jq
    yq
    hexyl
    hyperfine
    tokei
    binutils

    # ========================
    # LANGUAGE SERVERS
    # ========================
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    rust-analyzer
    python3Packages.python-lsp-server
    lua-language-server
    marksman
    clang-tools

    # ========================
    # CONTAINERS & VIRTUALIZATION
    # ========================
    docker
    docker-compose
    podman
    distrobox
    virt-manager
    virt-viewer
    qemu
    qemu-utils
    qemu_full
    quickemu
    libvirt
    spice
    spice-gtk
    spice-protocol
    spice-vdagent
    vde2
    bridge-utils
    dnsmasq
    OVMF
    virtualbox
    vagrant
    libguestfs
    guestfs-tools
    openvswitch
    virt-top

    # ========================
    # INFRASTRUCTURE & DEVOPS
    # ========================
    ansible
    packer
    terraform

    # ========================
    # NETWORK TOOLS
    # ========================
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

    # ========================
    # SECURITY
    # ========================
    age
    sops
    aircrack-ng
    ettercap

    # ========================
    # CLI PRODUCTIVITY
    # ========================
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

    # ========================
    # GIT TOOLS
    # ========================
    git
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

    # ========================
    # FILE MANAGEMENT
    # ========================
    ranger
    nnn
    fff
    mc
    lf

    # ========================
    # MULTIMEDIA
    # ========================
    ffmpeg
    mpv
    imagemagick
    audacity
    handbrake
    vlc
    gimp
    inkscape
    krita
    obs-studio

    # ========================
    # GAMING
    # ========================
    steam
    lutris
    wine
    wineWowPackages.stable
    winetricks
    protontricks
    mangohud
    goverlay
    gamemode

    # ========================
    # GUI APPLICATIONS
    # ========================
    chromium
    firefox
    signal-desktop
    telegram-desktop
    thunderbird
    spotify
    kdePackages.okular
    zathura
    kdePackages.dolphin
    evince
    feh
    kdePackages.konsole
    paprefs
    protonup-qt
    transmission_4-gtk
    vscode
    keepassxc

    # ========================
    # SYSTEM MONITORING
    # ========================
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

    # ========================
    # INFORMATION & DOCUMENTATION
    # ========================
    tldr
    cheat
    taskwarrior2

    # ========================
    # QT6 PACKAGES FOR PLASMA 6
    # ========================
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    qt6.qtwayland
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwebengine

    # ========================
    # LOGITECH / GAMING MOUSE SUPPORT
    # ========================
    libratbag
    piper

    # ========================
    # THEMES & APPEARANCE
    # ========================
    catppuccin-kde
    catppuccin-gtk
    tela-circle-icon-theme
    papirus-icon-theme

    # ========================
    # FUN & ENTERTAINMENT
    # ========================
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

    # ========================
    # 🆕 NYE GUI PAKKER - PRODUCTIVITY
    # ========================
    libreoffice-fresh           # 📊 Komplet kontorpakke
    obsidian                    # 🗒️ Notes app med linking
    zotero                      # 📚 Reference management
    xournalpp                   # 📝 Handwritten notes & PDF annotation
    masterpdfeditor             # 📄 PDF editor
    freeplane                   # 🧠 Mind mapping
    cherrytree                  # 📑 Hierarchical note taking

    # ========================
    # 🆕 NYE GUI PAKKER - DEVELOPMENT
    # ========================
    dbeaver-bin                 # 🗄️ Universal database tool
    postman                     # 🌐 API development
    beekeeper-studio            # 🐝 Modern SQL editor
    sqlitebrowser               # 🔍 SQLite database browser
    lens                        # ☸️ Kubernetes IDE
    zed-editor                  # ⚡ High-performance code editor

    # ========================
    # 🆕 NYE GUI PAKKER - GAMING
    # ========================
    heroic                      # 🎮 Epic Games Launcher alternative
    bottles                     # 🍷 Easy Wine bottle management
    playonlinux                 # 🐧 Wine frontend
    minigalaxy                  # 🌌 GOG.com client
    retroarch                   # 🕹️ Retro game emulator
    pcsx2                       # 🎮 PlayStation 2 emulator
    dolphin-emu                 # 🐬 GameCube & Wii emulator

    # ========================
    # 🆕 NYE GUI PAKKER - MULTIMEDIA
    # ========================
    kdePackages.kdenlive        # 🎬 Video editor
    blender                     # 🎨 3D modeling & animation
    ardour                      # 🎵 Digital audio workstation
    reaper                      # 🎹 Audio production
    bitwig-studio               # 🎛️ Music creation system
    shotcut                     # ✂️ Video editor
    olive-editor                # 🎞️ Video editor

    # ========================
    # 🆕 NYE GUI PAKKER - COMMUNICATION
    # ========================
    discord                     # 💬 Gaming communication
    element-desktop             # 🔗 Matrix client
    slack                       # 💼 Team communication
    brave                       # 🦁 Privacy-focused browser
    zoom                        # 📹 Video conferencing
    teams                       # 👥 Microsoft Teams

    # ========================
    # 🆕 NYE GUI PAKKER - SYSTEM TOOLS
    # ========================
    baobab                     # 📊 Disk usage analyzer
    filezilla                  # 📁 FTP client
   # etcher                     # 💾 USB image writer
    remmina                    # 🖥️ Remote desktop client
    gnome-system-monitor       # 📈 System monitor
    lshw                       # 💻 Hardware information

    # ========================
    # 🆕 NYE GUI PAKKER - SECURITY
    # ========================
    bitwarden-desktop                   # 🔐 Password manager
    totp-cli                       # 🔑 2FA authenticator
    veracrypt                   # 🗂️ Disk encryption
    keepassxc                   # 🗝️ Password manager (already have, keeping for reference)

    # ========================
    # 🆕 NYE GUI PAKKER - SCIENTIFIC
    # ========================
    qgis                        # 🗺️ Geographic information system
    rstudio                     # 📊 R development environment
    anki                        # 🧠 Spaced repetition flashcards
    geogebra                   # 📐 Mathematics software

    # ========================
    # 🆕 NYE GUI PAKKER - KDE SPECIFIC
    # ========================
    kdePackages.kmail          # 📧 Email client
    kdePackages.kontact        # 👥 Personal information manager
    kdePackages.korganizer     # 📅 Calendar & scheduling
    kdePackages.kdevelop       # 💻 Integrated development environment
    kdePackages.ark            # 🗜️ Archiving tool
    kdePackages.filelight      # 📀 Disk usage visualizer
    kdePackages.sweeper        # 🧹 System cleaner

    # ========================
    # 🆕 NYE GUI PAKKER - MISC
    # ========================
    onlyoffice-bin             # 📑 Office suite
    joplin-desktop            # 📝 Note taking
    typora                     # ✍️ Markdown editor
    remarkable                 # 📘 Markdown notes
    figma-linux               # 🎨 Design tool
    penpot                    # 🎨 Open-source design tool
  ];

  # ========================
  # ENVIRONMENT VARIABLES
  # ========================
  environment.variables = {
    # Wayland support for Electron apps
    NIXOS_OZONE_WL = "1";
    # Better performance for some applications
    __GL_THREADED_OPTIMIZATIONS = "1";
    # Vulkan layer path
    VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  };

  # ========================
  # PACKAGE CONFIGURATION
  # ========================
  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;

    # Allow packages with broken dependencies (use with caution)
    allowBroken = false;

    # Allow unsupported system packages
    allowUnsupportedSystem = false;

    # Package overrides
    packageOverrides = pkgs: {
      # Custom package configurations can go here
    };
  };
}
