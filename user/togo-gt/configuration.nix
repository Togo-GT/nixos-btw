# /etc/nixos/configuration.nix - FIXED with Python package overlay
{ config, pkgs, ... }:

{
  # Add overlay to fix Python package version conflicts
  nixpkgs.overlays = [
    (final: prev: {
      python311 = prev.python311.override {
        packageOverrides = python-final: python-prev: {
          # Fix aioquic dependencies
          aioquic = python-prev.aioquic.overridePythonAttrs (old: {
            # Relax version constraints temporarily
            propagatedBuildInputs = builtins.filter
              (x: !(prev.lib.getName x == "cryptography" || prev.lib.getName x == "pyopenssl"))
              old.propagatedBuildInputs;
          });
        };
      };
    })
  ];

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "splash"
      "nvidia-drm.modeset=1"
      "nowatchdog"
      "tsc=reliable"
      "nohibernate"
      "nvreg_EnableMSI=1"
      "mitigations=off"
      "preempt=full"
      "transparent_hugepage=always"
    ];

    initrd = {
      availableKernelModules = [
        "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"
      ];
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
      systemd.enable = true;
    };

    kernelModules = [
      "fuse" "v4l2loopback" "snd-aloop" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
      "vboxdrv" "vboxnetadp" "vboxnetflt" "vboxpci"
      "kvm" "kvm-intel"
    ];

    extraModprobeConfig = ''
      options nvidia NVreg_EnableMSI=1
      options nvidia-drm modeset=1
    '';
  };

  nixpkgs.config.allowUnsupportedSystem = true;

  # Hardware Configuration
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      forceFullCompositionPipeline = true;
      powerManagement = {
        enable = true;
      };

      prime = {
        sync.enable = true;
        offload.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        mesa
        nvidia-vaapi-driver
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Enable sane scanner support
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  # System Services
  services = {
    printing = {
      enable = true;
      webInterface = true;
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    pulseaudio = {
      enable = false;
      support32Bit = true;
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "dk";
        variant = "";
      };
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };

    desktopManager.plasma6.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
      };
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
      };
    };

    fstrim.enable = true;
    earlyoom.enable = true;
    flatpak.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    power-profiles-daemon.enable = false;

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    blueman.enable = true;
    fwupd.enable = true;
    thermald.enable = true;
    hardware.bolt.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
    };

    redis.servers.default = {
      enable = true;
      port = 6379;
      bind = "127.0.0.1";
    };

    syncthing = {
      enable = true;
      user = "togo-gt";
      dataDir = "/home/togo-gt/Sync";
      configDir = "/home/togo-gt/.config/syncthing";
    };

    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };

    gvfs = {
      enable = true;
    };

    udisks2 = {
      enable = true;
    };

    samba = {
      enable = true;
      openFirewall = true;
    };

    dbus = {
      enable = true;
      packages = with pkgs; [ dconf ];
    };

    geoclue2 = {
      enable = true;
    };
  };

  # Virtualization
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  # Networking
  networking = {
    hostName = "nixos-btw";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "wpa_supplicant";
        powersave = false;
      };
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    useDHCP = false;
    interfaces = {
      enp9s0.useDHCP = true;
      wlp8s0.useDHCP = true;
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 80 443 24800 5432
        27015 27016 27017 27036 27037
        631
        5353
      ];
      allowedTCPPortRanges = [
        { from = 27015; to = 27030; }
      ];
      allowedUDPPorts = [
        24800 27031 27036 3659 27015 27016
        5353
      ];
      allowedUDPPortRanges = [
        { from = 27000; to = 27031; }
        { from = 4380; to = 4380; }
      ];
    };
  };

  # Time & Locale
  time.timeZone = "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_DK.UTF-8";
    supportedLocales = [
      "en_DK.UTF-8/UTF-8"
      "da_DK.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LANG = "en_DK.UTF-8";
      LC_CTYPE = "en_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
    };
  };

  console.keyMap = "dk-latin1";

  # XDG Desktop
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
    mime.enable = true;
    icons.enable = true;
    sounds.enable = true;
  };

  programs = {
    dconf.enable = true;
    ssh.startAgent = false;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamescope.enable = true;
    gamemode.enable = true;

    partition-manager.enable = true;
    kdeconnect.enable = true;

    gnome-disks.enable = true;
  };

  # Security
  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = false;
    };
    protectKernelImage = true;
    auditd.enable = true;
    apparmor = {
      enable = true;
      packages = [ pkgs.apparmor-profiles ];
    };
    polkit.enable = true;

    pam = {
      services = {
        sddm = {
          enableGnomeKeyring = true;
        };
        login = {
          enableGnomeKeyring = true;
        };
      };
    };
  };

  # Nix Configuration - Allow broken packages temporarily
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;  # Temporary fix for Python package issues
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
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
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # Users
  users.users.togo-gt = {
    isNormalUser = true;
    description = "Togo-GT";
    extraGroups = [
      "networkmanager" "wheel" "input" "docker"
      "libvirtd" "vboxusers" "syncthing" "kvm"
      "audio" "video" "plugdev" "adb"
      "scanner" "lp" "samba"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzs4vJf1MW9Go0FzrBlUuqwwYDyDG7kP5KQYkxSplxF michael.kaare.nielsen@gmail.com"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      dejavu_fonts
      freefont_ttf
      corefonts
      liberation_ttf
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" "Noto Sans Mono" ];
        sansSerif = [ "DejaVu Sans" "Noto Sans" ];
        serif = [ "DejaVu Serif" "Noto Serif" ];
      };
    };
  };

  # System optimizations
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.dirty_expire_centisecs" = 3000;
  };

  # Environment
  environment.variables = {
    NIXOS_CONFIG = "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = "/home/togo-gt/nixos-config";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1";
    GDK_SCALE = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  system.userActivationScripts.setup-dirs = {
    text = ''
      mkdir -p /home/togo-gt/{Downloads,Documents,Music,Pictures,Videos,Sync,.config}
      chown -R togo-gt:users /home/togo-gt/
    '';
  };

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
    "jitsi-meet-1.0.8792"
  ];

  system.stateVersion = "25.05";
}
