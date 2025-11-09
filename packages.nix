# /etc/nixos/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ========================
    # SYSTEM ESSENTIALS & TOOLS
    # ========================
    vim
    neovim
    micro
    wget
    curl
    curlie
    git
    gitFull
    file
    pciutils
    usbutils
    lm_sensors
    inxi
    home-manager
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
    # MODERN CLI REPLACEMENTS
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
    duf
    procs
    sd
    choose
    zoxide
    fselect

    # ========================
    # QT6 PACKAGES FOR PLASMA 6 + KDE APPS
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
    # POWER MANAGEMENT
    # ========================
    powertop
    acpi
    cpupower-gui
    powerstat
    smartmontools
    s-tui
    stress-ng

    # ========================
    # DISK & STORAGE
    # ========================
    gnome-disk-utility
    gparted
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
    # NVIDIA & GRAPHICS
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
    python3
    jq
    yq
    hexyl
    hyperfine
    tokei
    pkg-config
    cmake
    gdb
    strace
    ltrace
    valgrind
    shellcheck
    hadolint

    # ========================
    # NIX ECOSYSTEM
    # ========================
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

    # ========================
    # VIRTUALIZATION
    # ========================
    virt-manager
    virt-viewer
    qemu
    qemu_kvm
    qemu-utils
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
    # NETWORK & SECURITY
    # ========================
    networkmanagerapplet
    wireshark
    nmap
    masscan
    iperf3
    age
    sops
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
    aircrack-ng
    ettercap

    # ========================
    # PRODUCTIVITY & INFO
    # ========================
    tree
    broot
    neofetch
    onefetch
    fastfetch
    tldr
    cheat
    cbonsai
    cmatrix
    figlet
    speedtest-cli
    fast-cli
    gotop
    btop
    htop
    taskwarrior3
    tmux
    tmuxp
    watch

    # ========================
    # GIT TOOLS
    # ========================
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
    # LANGUAGE SERVERS & DEVELOPMENT
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
    # GAMING & MULTIMEDIA
    # ========================
    mangohud
    goverlay
    gamemode
    obs-studio
    ffmpeg
    mpv
    imagemagick
    steam
    lutris
    wine
    wineWowPackages.stable
    winetricks
    protontricks

    # ========================
    # SYSTEM MONITORING
    # ========================
    iotop
    nethogs
    bandwhich
    zenith
    dool
    mission-center
    glances
    netdata

    # ========================
    # TERMINAL & SHELL
    # ========================
    tmux
    zoxide
    starship
    oh-my-posh
    direnv
    fish
    zsh

    # ========================
    # FILE MANAGEMENT
    # ========================
    ranger
    nnn
    fff
    mc
    lf

    # ========================
    # FUN & UTILITY
    # ========================
    cowsay
    fortune
    sl
    asciiquarium
    termscp
    cava
    pipes-rs
    lolcat

    # ========================
    # DEVELOPMENT & PROGRAMMING
    # ========================
    go
    nodejs
    perl
    python3Packages.pip
    pipx
    rustup
    binutils
    ansible
    packer
    terraform
    docker
    docker-compose
    podman

    # ========================
    # GUI APPLICATIONS
    # ========================
    chromium
    firefox
    signal-desktop
    telegram-desktop
    thunderbird
    audacity
    handbrake
    spotify
    vlc
    gimp
    inkscape
    krita
    kdePackages.okular
    zathura
    distrobox
    kdePackages.dolphin
    evince
    feh
    kdePackages.konsole
    paprefs
    protonup-qt
    transmission_4-qt

    # ========================
    # THEMES & ICONS
    # ========================
    catppuccin-kde
    catppuccin-gtk
    tela-circle-icon-theme
    papirus-icon-theme

    # ========================
    # ADDITIONAL TOOLS
    # ========================
    vscode
    keepassxc
  ];
}
