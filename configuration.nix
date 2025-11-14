# /etc/nixos/configuration.nix - FIXED RESTIC BACKUP SECTION
{ config, pkgs, ... }:

{
  # ===========================================================================
  # BOOT CONFIGURATION - SYSTEMETS OPLYSNINGSVEJE
  # ===========================================================================
  boot = {
    # -------------------------------------------------------------------------
    # BOOTLOADER CONFIGURATION - SYSTEMETS STARTMOTOR
    # -------------------------------------------------------------------------
    loader.systemd-boot.enable = true;        # 🚀 Modern bootloader with simplicity
    loader.efi.canTouchEfiVariables = true;   # 🔧 Allow EFI variable modification
    kernelPackages = pkgs.linuxPackages_latest; # 📦 Latest kernel for new hardware

    # -------------------------------------------------------------------------
    # KERNEL PARAMETERS - SYSTEMETS TUNING PARAMETRE
    # -------------------------------------------------------------------------
    kernelParams = [
      "quiet"                   # 🤫 Reduce boot noise
      "splash"                  # 🎨 Show splash screen
      "nvidia-drm.modeset=1"    # 🖥️ Enable NVIDIA DRM mode setting
      "nowatchdog"              # ⏰ Disable hardware watchdog
      "tsc=reliable"            # ⚡ Force TSC as reliable clock source
      "nohibernate"             # 💤 Disable hibernation
      "nvreg_EnableMSI=1"       # 🔧 Enable Message Signaled Interrupts for NVIDIA
      "mitigations=off"         # 🛡️ Disable CPU vulnerability mitigations for performance
      "preempt=full"            # ⚡ Full preemption for desktop responsiveness
      "transparent_hugepage=always" # 🚀 Always use transparent hugepages
    ];

    # -------------------------------------------------------------------------
    # INITRD KERNEL MODULES - SYSTEMETS TIDLIGSTE DRIVERE
    # -------------------------------------------------------------------------
    initrd.availableKernelModules = [
      "nvme"          # 💾 NVMe SSD support
      "xhci_pci"      # 🔌 USB 3.0 support
      "ahci"          # 💿 SATA AHCI controller support
      "usbhid"        # ⌨️ USB human interface devices
      "usb_storage"   # 💽 USB storage devices
      "sd_mod"        # 📀 SCSI disk support
    ];

    # -------------------------------------------------------------------------
    # KERNEL MODULES - SYSTEMETS DRIVER ØKOSYSTEM
    # -------------------------------------------------------------------------
    kernelModules = [
      "fuse"              # 📁 Filesystem in Userspace
      "v4l2loopback"      # 📹 Virtual video devices
      "snd-aloop"         # 🔊 Loopback audio device
      "nvidia"            # 🎮 NVIDIA graphics driver
      "nvidia_modeset"    # 🖥️ NVIDIA display mode setting
      "nvidia_uvm"        # 🧮 NVIDIA Unified Memory
      "nvidia_drm"        # 🎨 NVIDIA DRM driver
      "vboxdrv"           # 🖥️ VirtualBox host driver
      "vboxnetadp"        # 🌐 VirtualBox network adapter
      "vboxnetflt"        # 🔧 VirtualBox network filter
      "vboxpci"           # 🔌 VirtualBox PCI pass-through
      "kvm"               # ✅ ADDED - KVM virtualization
      "kvm-intel"         # ✅ ADDED - Intel KVM support
    ];
  };

  # ===========================================================================
  # FILESYSTEM CONFIGURATION - SYSTEMETS LAGERHIERARKI
  # ===========================================================================
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e439ce99-1952-496e-9e1d-63ca5992cf98";
    fsType = "ext4";
    options = ["defaults" "noatime" "nodiratime"]; # 🚀 Performance optimizations
  };

  # ===========================================================================
  # NVIDIA HARDWARE CONFIGURATION - GRAFISK ACCELERATION
  # ===========================================================================
  hardware.nvidia = {
    modesetting.enable = true;     # 🖥️ Enable kernel mode setting
    open = false;                  # 🔒 Use proprietary drivers
    nvidiaSettings = true;         # ⚙️ Enable NVIDIA control panel
    package = config.boot.kernelPackages.nvidiaPackages.stable; # 📦 Stable driver package
    forceFullCompositionPipeline = true; # 🎨 Force full composition pipeline for tearing prevention

    # -------------------------------------------------------------------------
    # PRIME CONFIGURATION - HYBRID GRAPHICS MANAGEMENT
    # -------------------------------------------------------------------------
    prime = {
      sync.enable = true;          # 🔄 Enable PRIME sync
      offload.enable = false;      # ❌ Disable offload (using sync instead)
      intelBusId = "PCI:0:2:0";    # 🔌 Intel integrated GPU bus ID
      nvidiaBusId = "PCI:1:0:0";   # 🎮 NVIDIA discrete GPU bus ID
    };
  };

  # ===========================================================================
  # CPU & MICROCODE CONFIGURATION - PROCESSOR OPTIMIZERING
  # ===========================================================================
  hardware.cpu.intel.updateMicrocode = true; # 🔧 Update Intel CPU microcode

  # ===========================================================================
  # GRAPHICS STACK CONFIGURATION - VISUEL PERFORMANCE
  # ===========================================================================
  hardware.graphics = {
    enable = true;          # 🎨 Enable graphics stack
    enable32Bit = true;     # 🔧 32-bit graphics support for compatibility

    # -------------------------------------------------------------------------
    # EXTRA GRAPHICS PACKAGES - ACCELERATIONSBIBLIOTEKER
    # -------------------------------------------------------------------------
    extraPackages = with pkgs; [
      libva-vdpau-driver    # 📺 VA-API to VDPAU bridge
      libvdpau-va-gl        # 🔄 VDPAU to VA-API bridge
      mesa                  # 🎨 OpenGL implementation
      nvidia-vaapi-driver   # 📹 VA-API implementation for NVIDIA
    ];

    # -------------------------------------------------------------------------
    # 32-BIT GRAPHICS PACKAGES - KOMPATIBILITETSBIBLIOTEKER
    # -------------------------------------------------------------------------
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva                # 🎨 Video Acceleration API (32-bit)
      mesa                 # 🎨 OpenGL implementation (32-bit)
      nvidia-vaapi-driver  # 📹 VA-API for NVIDIA (32-bit)
    ];
  };

  # ===========================================================================
  # PRINTING SERVICES - UDTRYKKERSTØTTE
  # ===========================================================================
  services.printing.enable = true; # 🖨️ Enable CUPS printing service

  # ===========================================================================
  # REALTIME KIT - AUDIO PERFORMANCE
  # ===========================================================================
  security.rtkit.enable = true;    # 🔊 Realtime kit for audio processing

  # ===========================================================================
  # PIPEWIRE CONFIGURATION - MODERNE LYD SYSTEM
  # ===========================================================================
  services.pipewire = {
    enable = true;           # 🎵 Enable PipeWire sound server
    alsa.enable = true;      # 🔌 ALSA support
    alsa.support32Bit = true; # 🔧 32-bit ALSA application support
    pulse.enable = true;     # ❤️ PulseAudio compatibility layer
    jack.enable = true;      # 🎛️ JACK audio server support
  };

  # ===========================================================================
  # BLUETOOTH CONFIGURATION - TRÅDLØS FORBINDELSE
  # ===========================================================================
  hardware.bluetooth = {
    enable = true;           # 🔵 Enable Bluetooth support
    powerOnBoot = true;      # 🔌 Power on Bluetooth on boot
  };
  services.blueman.enable = true; # 🎛️ Bluetooth manager GUI

  # ===========================================================================
  # NETWORKING CONFIGURATION - NETVÆRKSFORBINDELSER
  # ===========================================================================
  networking = {
    hostName = "nixos-btw";  # 🖥️ System hostname
    networkmanager.enable = true; # 🌐 NetworkManager for network management
    nameservers = [ "1.1.1.1" "1.0.0.1" ]; # 🌍 Cloudflare DNS servers
  };

  # ===========================================================================
  # TIME & TIMEZONE CONFIGURATION - TIDSREGIONER
  # ===========================================================================
  time.timeZone = "Europe/Copenhagen"; # 🇩🇰 Copenhagen timezone

  # ===========================================================================
  # TIME SYNCHRONIZATION - PRÆCIS TIDSSYNKRONISERING
  # ===========================================================================
  services.timesyncd.enable = true; # ⏰ Systemd time synchronization
  services.timesyncd.servers = [
    "0.dk.pool.ntp.org"    # 🇩🇰 Danish NTP server 0
    "1.dk.pool.ntp.org"    # 🇩🇰 Danish NTP server 1
    "2.dk.pool.ntp.org"    # 🇩🇰 Danish NTP server 2
    "3.dk.pool.ntp.org"    # 🇩🇰 Danish NTP server 3
  ];

  # ===========================================================================
  # INTERNATIONALIZATION - SPROG OG REGIONALE INDSTILLINGER
  # ===========================================================================
  i18n = {
    defaultLocale = "en_DK.UTF-8"; # 🏴‍☠️ Default locale: English in Denmark
    supportedLocales = [
      "en_DK.UTF-8/UTF-8"  # 🇬🇧 English in Denmark
      "da_DK.UTF-8/UTF-8"  # 🇩🇰 Danish in Denmark
    ];
    extraLocaleSettings = {
      LANG = "en_DK.UTF-8";                # 🏴‍☠️ System language
      LC_CTYPE = "en_DK.UTF-8";            # 🔤 Character classification
      LC_NUMERIC = "da_DK.UTF-8";          # 🔢 Numbers (Danish format)
      LC_TIME = "da_DK.UTF-8";             # 📅 Time and date (Danish format)
      LC_MONETARY = "da_DK.UTF-8";         # 💰 Currency (Danish format)
      LC_ADDRESS = "da_DK.UTF-8";          # 🏠 Addresses (Danish format)
      LC_IDENTIFICATION = "da_DK.UTF-8";   # 🆔 Identification (Danish format)
      LC_MEASUREMENT = "da_DK.UTF-8";      # 📏 Measurement (Danish metric system)
      LC_PAPER = "da_DK.UTF-8";            # 📄 Paper sizes (Danish format)
      LC_TELEPHONE = "da_DK.UTF-8";        # 📞 Telephone numbers (Danish format)
      LC_NAME = "da_DK.UTF-8";             # 👤 Names (Danish format)
    };
  };

  # ===========================================================================
  # KEYBOARD LAYOUT - TASTATUROPLÆG
  # ===========================================================================
  services.xserver.xkb = {
    layout = "dk";          # 🇩🇰 Danish keyboard layout
    variant = "";           # 🔤 No variant (standard Danish)
  };
  console.keyMap = "dk-latin1"; # 💻 Console keymap (Danish Latin-1)

  # ===========================================================================
  # XSERVER CONFIGURATION - GRAFISK SYSTEM
  # ===========================================================================
  services.xserver = {
    enable = true;                  # 🖥️ Enable X11 server
    videoDrivers = [ "nvidia" ];    # 🎮 NVIDIA graphics drivers
  };

  # ===========================================================================
  # XDG MIME - FILTYPE ASSOCIATIONER
  # ===========================================================================
  xdg.mime.enable = true;           # 📁 Enable XDG MIME type database

  # ===========================================================================
  # DISPLAY MANAGER - LOGIN SKÆRM
  # ===========================================================================
  services.displayManager.sddm = {
    enable = true;          # 🎨 Enable SDDM display manager
    wayland.enable = true;  # 🚀 Enable Wayland support in SDDM
  };

  # ===========================================================================
  # DESKTOP ENVIRONMENT - SKRIVEBORDSMILJØ
  # ===========================================================================
  services.desktopManager.plasma6.enable = true; # 🎨 KDE Plasma 6 desktop

  # ===========================================================================
  # XDG DESKTOP PORTALS - SKRIVEBORDSINTEGRATION
  # ===========================================================================
  xdg.portal = {
    enable = true;          # 🚪 Enable XDG desktop portals
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde  # 🎨 KDE desktop portal
      xdg-desktop-portal-gtk              # 🪟 GTK desktop portal
    ];
  };

  # ===========================================================================
  # DCONF CONFIGURATION - GNOME/KONFIGURATIONSLAGER
  # ===========================================================================
  programs.dconf.enable = true;     # ⚙️ Enable dconf configuration system

  # ===========================================================================
  # GIT CONFIGURATION - VERSIONSCONTROL
  # ===========================================================================
  #programs.git = {
  #  enable = true;                  # 🔧 Enable Git
  #  config = {
  #    user.name = "Togo-GT";                           # 👤 Git username
  #    user.email = "michael.kaare.nielsen@gmail.com"; # 📧 Git email
  #    init.defaultBranch = "main";                     # 🌿 Default branch name
  #  };
 # };

  # ===========================================================================
  # USER CONFIGURATION - BRUGERDEFINITION
  # ===========================================================================
  users.users.togo-gt = {
    isNormalUser = true;            # 👤 Regular user (not system account)
    description = "Togo-GT";        # 📝 User description
    extraGroups = [
      "networkmanager"  # 🌐 Network management privileges
      "wheel"           # ⚙️ Sudo privileges
      "input"           # ⌨️ Input device access
      "docker"          # 🐳 Docker container access
      "libvirtd"        # 🔮 Virtualization access
      "vboxusers"       # 🖥️ VirtualBox user group
      "syncthing"       # 🔄 Syncthing file synchronization
      "kvm"             # ✅ ADDED - KVM access
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzs4vJf1MW9Go0FzrBlUuqwwYDyDG7kP5KQYkxSplxF michael.kaare.nielsen@gmail.com" # 🔑 SSH public key
    ];
    packages = with pkgs; [
      kdePackages.kate  # 📝 KDE Advanced Text Editor
    ];
  };

  # ===========================================================================
  # SSH AGENT - SIKKER AUTHENTICATION
  # ===========================================================================
  programs.ssh.startAgent = true;   # 🔐 Start SSH agent automatically

  # ===========================================================================
  # NIXPKGS CONFIGURATION - PAKKEHÅNDTERING
  # ===========================================================================
  nixpkgs.config.allowUnfree = true; # 🔓 Allow proprietary packages

  # ===========================================================================
  # NIX SETTINGS - NIX KONFIGURATION
  # ===========================================================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]; # 🚀 Enable experimental features
    download-buffer-size = "100000000";                 # 📦 Larger download buffer
    auto-optimise-store = true;                         # 🔧 Auto-optimize Nix store
    substituters = [
      "https://cache.nixos.org"               # 🏢 Official NixOS cache
      "https://nix-community.cachix.org"      # 👥 Community cache
      "https://hyprland.cachix.org"           # 🎨 Hyprland cache
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="      # 🔑 Official NixOS key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # 🔑 Community key
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="  # 🔑 Hyprland key
    ];
    cores = 0;              # 🔢 Use all available CPU cores
    max-jobs = "auto";      # ⚙️ Automatic job parallelism
  };

  # ===========================================================================
  # GARBAGE COLLECTION - SYSTEMOPRYDNING
  # ===========================================================================
  nix.gc = {
    automatic = true;               # 🤖 Automatic garbage collection
    dates = "weekly";               # 📅 Run once per week
    options = "--delete-older-than 7d"; # 🗑️ Delete generations older than 7 days
  };

  # ===========================================================================
  # FSTRIM SERVICE - SSD OPTIMERING
  # ===========================================================================
  services.fstrim.enable = true;    # 💾 Enable SSD TRIM support

  # ===========================================================================
  # EARLY OOM - MEMORY MANAGEMENT
  # ===========================================================================
  services.earlyoom.enable = true;  # 🚨 Early out-of-memory killer

  # ===========================================================================
  # FLATPAK SUPPORT - UNIVERSAL PAKKEHÅNDTERING
  # ===========================================================================
  services.flatpak.enable = true;   # 📦 Enable Flatpak application support

  # ===========================================================================
  # POWER MANAGEMENT - STRØMHÅNDTERING
  # ===========================================================================
  services.power-profiles-daemon.enable = false; # ❌ Disable GNOME power profiles
  services.tlp = {
    enable = true;                  # 🔋 Enable TLP power management
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";   # ⚡ Performance on AC power
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";    # 🔋 Power save on battery
    };
  };

  # ===========================================================================
  # GAMING CONFIGURATION - SPILOPTIMERING
  # ===========================================================================
  programs.steam = {
    enable = true;                          # 🎮 Enable Steam gaming platform
    remotePlay.openFirewall = true;         # 🌐 Open firewall for Remote Play
    dedicatedServer.openFirewall = true;    # 🖥️ Open firewall for dedicated servers
    extraCompatPackages = with pkgs; [
      proton-ge-bin          # 🍷 Proton-GE for Windows game compatibility
    ];
  };
  programs.gamescope.enable = true;         # 🎯 Gamescope compositor for gaming
  programs.gamemode.enable = true;          # 🚀 Gamemode for gaming optimizations

  # ===========================================================================
  # HARDWARE SUPPORT - THUNDERBOLT ENHEDSR
  # ===========================================================================
  services.hardware.bolt.enable = true;     # ⚡ Thunderbolt device support

  # ===========================================================================
  # BACKUP CONFIGURATION - SIKKERHEDSKOPIERING (FIXED VERSION)
  # ===========================================================================
  services.restic.backups.system = {
    initialize = true;                      # 🔧 Initialize repository if missing
    repository = "/var/backup";             # 📁 Backup repository location
    passwordFile = "/etc/restic/password";  # 🔐 Password file for encryption

    # 🚨 AUTO-CREATE PASSWORD FILE ON FIRST RUN - FIXES MISSING FILE ERROR
    # This ensures the password file exists before restic tries to use it
    preBackupCommands = ''
      echo "🔐 Setting up Restic backup environment..."
      mkdir -p /var/backup /etc/restic

      # Only create password file if it doesn't exist
      if [ ! -f /etc/restic/password ]; then
        echo "📝 Generating secure Restic backup password..."
        ${pkgs.openssl}/bin/openssl rand -base64 32 > /etc/restic/password
        chmod 600 /etc/restic/password
        echo "✅ Backup password generated and secured"
      else
        echo "🔑 Using existing backup password"
      fi

      # Set proper permissions on backup directory
      chmod 700 /var/backup
      echo "🚀 Restic backup environment ready"
    '';

    paths = [ "/home" "/etc/nixos" ];       # 📂 Paths to backup
    timerConfig = {
      OnCalendar = "daily";                 # 📅 Run backup daily at 02:00
      Persistent = true;                    # 🔄 Run missed backups on next boot
      RandomizedDelaySec = "1h";            # ⏰ Random delay to avoid system load spikes
    };

    # 🧹 PRUNE OLD BACKUPS AUTOMATICALLY
    pruneOpts = [
      "--keep-daily 7"      # 📊 Keep daily backups for 7 days
      "--keep-weekly 5"     # 📈 Keep weekly backups for 5 weeks
      "--keep-monthly 12"   # 🗓️ Keep monthly backups for 12 months
      "--keep-yearly 2"     # 🎉 Keep yearly backups for 2 years
    ];

    # 🔧 BACKUP OPTIONS FOR BETTER PERFORMANCE
    extraOptions = [
      "--verbose"           # 📋 Verbose output for debugging
      "--exclude-caches"    # 🗑️ Exclude cache directories
    ];

    # 🛡️ EXCLUDE PATTERNS TO SAVE SPACE
    exclude = [
      "*.tmp"               # 🗑️ Temporary files
      "*.log"               # 📊 Log files
      "*.cache"             # 🗂️ Cache directories
      "node_modules"        # 📦 Node.js dependencies
      "__pycache__"         # 🐍 Python cache
      ".git"                # 🔧 Git repositories
      "*.o"                 # 🔨 Compiled object files
      "*.so"                # 🔧 Shared libraries
    ];
  };

  # ===========================================================================
  # SYNCTHING CONFIGURATION - FILSYNKRONISERING
  # ===========================================================================
  services.syncthing = {
    enable = true;                          # 🔄 Enable Syncthing
    user = "togo-gt";                       # 👤 Syncthing user
    dataDir = "/home/togo-gt/Sync";         # 📁 Synchronization directory
    configDir = "/home/togo-gt/.config/syncthing"; # ⚙️ Configuration directory
  };

  # ===========================================================================
  # DATABASE SERVICES - UDVIKLINGSDATABASER
  # ===========================================================================
  services.postgresql = {
    enable = true;                          # 🐘 Enable PostgreSQL database
    package = pkgs.postgresql_16;           # 📦 PostgreSQL 16 package
    enableTCPIP = true;                     # 🌐 Enable TCP/IP connections
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust                   # 🔓 Trust local connections
      host all all 127.0.0.1/32 trust       # 🔓 Trust localhost IPv4
      host all all ::1/128 trust            # 🔓 Trust localhost IPv6
    '';
  };

  # ===========================================================================
  # REDIS SERVICE - NØGLEDATABASER
  # ===========================================================================
  services.redis.servers."" = {
    enable = true;                          # 🗃️ Enable Redis server
    port = 6379;                            # 🔌 Redis port number
  };

  # ===========================================================================
  # VIRTUALIZATION - VIRTUALBOX SUPPORT
  # ===========================================================================
  virtualisation.virtualbox = {
    host = {
      enable = true;                        # 🖥️ Enable VirtualBox host
      enableExtensionPack = true;           # 📦 Enable VirtualBox extension pack
    };
  };

  # ===========================================================================
  # CONTAINERIZATION - DOCKER & LIBVIRT
  # ===========================================================================
  virtualisation = {
    docker = {
      enable = true;                        # 🐳 Enable Docker
      rootless = {
        enable = true;                      # 🔒 Rootless Docker mode
        setSocketVariable = true;           # 🔌 Set DOCKER_HOST variable
      };
    };
    libvirtd = {
      enable = true;                        # 🔮 Enable libvirt virtualization
      qemu = {
        runAsRoot = true;                   # 👑 Run QEMU as root
        swtpm.enable = true;                # 🔒 Software TPM support
      };
    };
  };

  # ===========================================================================
  # SYSTEM SERVICES - YDERLIGERE SYSTEMTJENESTER
  # ===========================================================================
  services = {
    avahi = {
      enable = true;                        # 🌐 Zero-configuration networking
      nssmdns4 = true;                      # 🔍 mDNS name resolution
    };
    fwupd.enable = true;                    # 🔄 Firmware update service
    thermald.enable = true;                 # 🌡️ Thermal monitoring daemon
  };

  # ===========================================================================
  # FONT CONFIGURATION - TYPOGRAFI OG SKRIFTTYPER
  # ===========================================================================
  fonts = {
    enableDefaultPackages = true;           # 📚 Enable default font packages
    packages = with pkgs; [
      noto-fonts               # 🌍 Universal font coverage
      noto-fonts-cjk-sans      # 🇯🇵🇰🇷🇨🇳 Chinese, Japanese, Korean sans-serif
      noto-fonts-color-emoji   # 😀 Color emoji font
      nerd-fonts.fira-code     # 🔤 Fira Code with programming ligatures
      nerd-fonts.jetbrains-mono # 💻 JetBrains Mono developer font
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];  # 💻 Terminal fonts
        sansSerif = [ "Noto Sans" ];               # 📝 Sans-serif fonts
        serif = [ "Noto Serif" ];                  # 📚 Serif fonts
      };
    };
  };

  # ===========================================================================
  # SSH CONFIGURATION - SIKKER FJERNFORBINDELSE
  # ===========================================================================
  services.openssh = {
    enable = true;                          # 🔐 Enable SSH server
    settings = {
      PasswordAuthentication = false;       # ❌ Disable password authentication
      PermitRootLogin = "no";               # ❌ Disable root SSH login
    };
  };

  # ===========================================================================
  # FIREWALL CONFIGURATION - NETVÆRKSSIKKERHED
  # ===========================================================================
  networking.firewall = {
    allowedTCPPorts = [
      22        # 🔐 SSH
      80        # 🌐 HTTP
      443       # 🔒 HTTPS
      24800     # 🔄 Syncthing
      27015     # 🎮 Steam
      27036     # 🎮 Steam
      27037     # 🎮 Steam
      27016     # 🎮 Steam
      27017     # 🎮 Steam
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; } # 🎮 Steam port range
    ];
    allowedUDPPorts = [
      24800     # 🔄 Syncthing
      27031     # 🎮 Steam
      27036     # 🎮 Steam
      3659      # 🎮 Steam
      27015     # 🎮 Steam
      27016     # 🎮 Steam
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27031; } # 🎮 Steam UDP range
      { from = 4380; to = 4380; }   # 🎮 Steam In-Home Streaming
    ];
  };

  # ===========================================================================
  # SECURITY CONFIGURATION - SYSTEMSIKKERHED
  # ===========================================================================
  security = {
    sudo = {
      wheelNeedsPassword = false;           # 🔓 Sudo without password for wheel group
      execWheelOnly = false;                # 🔧 Allow sudo from other groups
    };
    protectKernelImage = true;              # 🛡️ Protect kernel from modification
    auditd.enable = true;                   # 📊 System auditing daemon
    apparmor = {
      enable = true;                        # 🛡️ Enable AppArmor MAC system
      packages = [ pkgs.apparmor-profiles ]; # 📦 AppArmor profiles
    };
  };

  # ===========================================================================
  # SYSTEM STATE VERSION - KONFIGURATIONSVERSION
  # ===========================================================================
  system.stateVersion = "25.05";            # 🏷️ NixOS version this config is for
}
