# configuration.nix - Main system configuration
{ config, pkgs, ... }:

{
  # =============================================
  # BOOT CONFIGURATION
  # =============================================
  boot = {
    # Use systemd-boot as the bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel parameters for performance and compatibility
    kernelParams = [
      "quiet"
      "splash"
      "nvidia-drm.modeset=1"  # Enable NVIDIA DRM mode setting
      "nowatchdog"            # Disable watchdog timers
      "tsc=reliable"          # Force reliable TSC
      "nohibernate"           # Disable hibernation
      "nvreg_EnableMSI=1"     # Enable MSI for NVIDIA
      "mitigations=off"       # Disable CPU vulnerability mitigations for performance
      "preempt=full"          # Full kernel preemption
      "transparent_hugepage=always"  # Always use transparent huge pages
    ];

    # Kernel modules to load in initrd
    initrd.availableKernelModules = [
      "nvme"          # NVMe storage
      "xhci_pci"      # USB 3.0 controller
      "ahci"          # SATA controller
      "usbhid"        # USB HID devices
      "usb_storage"   # USB storage
      "sd_mod"        # SCSI disk support
    ];

    # Kernel modules to load
    kernelModules = [
      "fuse"          # Filesystem in Userspace
      "v4l2loopback"  # Virtual video devices
      "snd-aloop"     # ALSA loopback sound
      "nvidia"        # NVIDIA graphics
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "vboxdrv"       # VirtualBox
      "vboxnetadp"
      "vboxnetflt"
      "vboxpci"
      "kvm"           # Kernel Virtual Machine
      "kvm-intel"     # Intel KVM support
    ];
  };

  # =============================================
  # FILESYSTEM CONFIGURATION
  # =============================================
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e439ce99-1952-496e-9e1d-63ca5992cf98";
    fsType = "ext4";
    options = ["defaults" "noatime" "nodiratime"];  # Performance options
  };

  # =============================================
  # NVIDIA GRAPHICS CONFIGURATION
  # =============================================
  hardware.nvidia = {
    modesetting.enable = true;     # Required for Wayland
    open = false;                  # Use proprietary drivers
    nvidiaSettings = true;         # Enable nvidia-settings tool
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    forceFullCompositionPipeline = true;  # Fix screen tearing

    # Prime configuration for hybrid graphics (Intel + NVIDIA)
    prime = {
      sync.enable = true;          # Use PRIME sync
      offload.enable = false;      # Disable offload mode
      intelBusId = "PCI:0:2:0";    # Intel GPU bus ID
      nvidiaBusId = "PCI:1:0:0";   # NVIDIA GPU bus ID
    };
  };

  # =============================================
  # HARDWARE CONFIGURATION
  # =============================================
  hardware.cpu.intel.updateMicrocode = true;  # Intel CPU microcode updates

  # Graphics and video acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Enable 32-bit support for compatibility

    # Video acceleration packages
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
      mesa
      nvidia-vaapi-driver
    ];

    # 32-bit video acceleration packages
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      mesa
      nvidia-vaapi-driver
    ];
  };

  # =============================================
  # PRINTING SERVICES
  # =============================================
  services.printing.enable = true;

  # =============================================
  # AUDIO CONFIGURATION
  # =============================================
  security.rtkit.enable = true;  # Realtime kit for audio

  # PipeWire for modern audio handling
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;  # 32-bit audio support
    pulse.enable = true;       # PulseAudio compatibility
    jack.enable = true;        # JACK audio support
  };

  # =============================================
  # BLUETOOTH CONFIGURATION
  # =============================================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;  # Enable Bluetooth on boot
  };
  services.blueman.enable = true;  # Bluetooth manager GUI

  # =============================================
  # NETWORKING CONFIGURATION
  # =============================================
  networking = {
    hostName = "nixos-btw";  # System hostname
    networkmanager.enable = true;  # Use NetworkManager
    nameservers = [ "1.1.1.1" "1.0.0.1" ];  # Cloudflare DNS
  };

  # =============================================
  # TIME AND LOCALE CONFIGURATION
  # =============================================
  time.timeZone = "Europe/Copenhagen";  # Copenhagen timezone

  # Time synchronization
  services.timesyncd.enable = true;
  services.timesyncd.servers = [
    "0.dk.pool.ntp.org"
    "1.dk.pool.ntp.org"
    "2.dk.pool.ntp.org"
    "3.dk.pool.ntp.org"
  ];

  # Internationalization and locale settings
  i18n = {
    defaultLocale = "en_DK.UTF-8";  # English with Danish formatting
    supportedLocales = [
      "en_DK.UTF-8/UTF-8"
      "da_DK.UTF-8/UTF-8"
    ];
    # Fine-grained locale settings
    extraLocaleSettings = {
      LANG = "en_DK.UTF-8";
      LC_CTYPE = "en_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";     # Danish number formatting
      LC_TIME = "da_DK.UTF-8";        # Danish time formatting
      LC_MONETARY = "da_DK.UTF-8";    # Danish currency formatting
      LC_ADDRESS = "da_DK.UTF-8";     # Danish address formatting
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8"; # Danish measurement units
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";   # Danish phone number format
      LC_NAME = "da_DK.UTF-8";        # Danish name formatting
    };
  };

  # Keyboard layout
  services.xserver.xkb = {
    layout = "dk";   # Danish keyboard layout
    variant = "";
  };
  console.keyMap = "dk-latin1";  # Console keymap

  # =============================================
  # DISPLAY CONFIGURATION
  # =============================================
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];  # Use NVIDIA drivers
  };

  # Modern desktop portal for Wayland applications
  xdg.mime.enable = true;

  # SDDM display manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # KDE Plasma 6 desktop environment
  services.desktopManager.plasma6.enable = true;

  # Desktop portals for file dialogs and more
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde  # KDE portal
      xdg-desktop-portal-gtk              # GTK portal
    ];
  };

  # DConf for GNOME/GTK application settings
  programs.dconf.enable = true;

  # =============================================
  # GIT CONFIGURATION
  # =============================================
  programs.git = {
    enable = true;
    config = {
      user.name = "Togo-GT";
      user.email = "michael.kaare.nielsen@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # =============================================
  # USER CONFIGURATION
  # =============================================
  users.users.togo-gt = {
    isNormalUser = true;
    description = "Togo-GT";
    extraGroups = [
      "networkmanager"  # Network management
      "wheel"           # Sudo access
      "input"           # Input device access
      "docker"          # Docker access
      "libvirtd"        # Virtualization access
      "vboxusers"       # VirtualBox access
      "syncthing"       # Syncthing access
      "kvm"             # KVM virtualization access
    ];
    # SSH authorized keys for passwordless login
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzs4vJf1MW9Go0FzrBlUuqwwYDyDG7kP5KQYkxSplxF michael.kaare.nielsen@gmail.com"
    ];
    packages = with pkgs; [
      kdePackages.kate  # KDE advanced text editor
    ];
  };

  # SSH agent for key management
  programs.ssh.startAgent = true;

  # =============================================
  # NIX PACKAGE MANAGER CONFIGURATION
  # =============================================
  nixpkgs.config.allowUnfree = true;  # Allow proprietary packages

  # Nix settings and optimizations
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];  # Modern Nix features
    download-buffer-size = "100000000";  # Larger download buffer
    auto-optimise-store = true;          # Automatically optimize store

    # Binary caches for faster downloads
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    cores = 0;        # Use all available cores
    max-jobs = "auto"; # Automatic job parallelism
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;    # Run GC automatically
    dates = "weekly";    # Run once per week
    options = "--delete-older-than 7d";  # Keep only last 7 days
  };

  # =============================================
  # SYSTEM SERVICES AND OPTIMIZATIONS
  # =============================================
  services.fstrim.enable = true;    # SSD trim support
  services.earlyoom.enable = true;  # Early OOM killer
  services.flatpak.enable = true;   # Flatpak support

  # Power management - TLP for better battery life
  services.power-profiles-daemon.enable = false;  # Disable conflicting service
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";   # Performance on AC power
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";    # Power save on battery
    };
  };

  # =============================================
  # GAMING CONFIGURATION
  # =============================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;      # Allow Steam Remote Play
    dedicatedServer.openFirewall = true; # Allow dedicated servers
    extraCompatPackages = with pkgs; [
      proton-ge-bin  # Proton-GE for better game compatibility
    ];
  };
  programs.gamescope.enable = true;  # SteamOS gamescope compositor
  programs.gamemode.enable = true;   # Feral Interactive's GameMode

  # =============================================
  # HARDWARE SERVICES
  # =============================================
  services.hardware.bolt.enable = true;  # Thunderbolt support

  # =============================================
  # BACKUP CONFIGURATION
  # =============================================
  services.restic.backups.system = {
    initialize = true;
    repository = "/var/backup";
    passwordFile = "/etc/restic/password";
    paths = [ "/home" "/etc/nixos" ];  # Backup home and config
    timerConfig = {
      OnCalendar = "daily";  # Daily backups
      Persistent = true;
    };
  };

  # =============================================
  # FILE SYNCHRONIZATION
  # =============================================
  services.syncthing = {
    enable = true;
    user = "togo-gt";
    dataDir = "/home/togo-gt/Sync";
    configDir = "/home/togo-gt/.config/syncthing";
  };

  # =============================================
  # DATABASE SERVICES
  # =============================================
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    # Trust authentication for local connections
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  # Redis in-memory data store
  services.redis.servers."" = {
    enable = true;
    port = 6379;
  };

  # =============================================
  # VIRTUALIZATION AND CONTAINERS
  # =============================================
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;  # VirtualBox extension pack
    };
  };

  virtualisation = {
    # Docker container platform
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    # Libvirt virtualization
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;  # Software TPM emulator
      };
    };
  };

  # =============================================
  # SYSTEM SERVICES
  # =============================================
  services = {
    avahi = {
      enable = true;      # Zero-config networking
      nssmdns4 = true;    # mDNS name resolution
    };
    fwupd.enable = true;   # Firmware updates
    thermald.enable = true; # Thermal management
  };

  # =============================================
  # FONT CONFIGURATION
  # =============================================
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts              # Google Noto fonts
      noto-fonts-cjk-sans     # Chinese/Japanese/Korean sans
      noto-fonts-color-emoji  # Color emoji support
      nerd-fonts.fira-code    # Fira Code with programming ligatures
      nerd-fonts.jetbrains-mono # JetBrains Mono font
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # =============================================
  # SECURITY AND FIREWALL
  # =============================================
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;  # Key-based auth only
      PermitRootLogin = "no";          # No root SSH login
    };
  };

  # Firewall configuration
  networking.firewall = {
    # Open ports for various services
    allowedTCPPorts = [
      22      # SSH
      80      # HTTP
      443     # HTTPS
      24800   # Syncthing
      27015   # Steam
      27036   # Steam
      27037   # Steam
      27016   # Steam
      27017   # MongoDB (if used)
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; }  # Steam port range
    ];
    allowedUDPPorts = [
      24800   # Syncthing
      27031   # Steam
      27036   # Steam
      3659    # Battle.net
      27015   # Steam
      27016   # Steam
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27031; }  # Steam UDP range
      { from = 4380; to = 4380; }    # Steam In-Home Streaming
    ];
  };

  # Security settings
  security = {
    sudo = {
      wheelNeedsPassword = false;  # No password for sudo for wheel group
      execWheelOnly = false;
    };
    protectKernelImage = true;     # Protect kernel from modification
    auditd.enable = true;          # Audit daemon for security monitoring
    apparmor = {
      enable = true;               # Application confinement
      packages = [ pkgs.apparmor-profiles ];  # AppArmor profiles
    };
  };

  # =============================================
  # SYSTEM STATE VERSION
  # =============================================
  system.stateVersion = "25.05";  # Don't change this
}
