{ config, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
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
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [
      "fuse"
      "v4l2loopback"
      "snd-aloop"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "vboxdrv"
      "vboxnetadp"
      "vboxnetflt"
      "vboxpci"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e439ce99-1952-496e-9e1d-63ca5992cf98";
    fsType = "ext4";
    options = ["defaults" "noatime" "nodiratime"];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    forceFullCompositionPipeline = true;
    prime = {
      sync.enable = true;
      offload.enable = false;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics = {
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

  services.printing.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  networking = {
    hostName = "nixos-btw";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  time.timeZone = "Europe/Copenhagen";

  services.timesyncd.enable = true;
  services.timesyncd.servers = [
    "0.dk.pool.ntp.org"
    "1.dk.pool.ntp.org"
    "2.dk.pool.ntp.org"
    "3.dk.pool.ntp.org"
  ];

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

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };
  console.keyMap = "dk-latin1";

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  xdg.mime.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  programs.dconf.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "Togo-GT";
      user.email = "michael.kaare.nielsen@gmail.com";
      init.defaultBranch = "main";
    };
  };

  users.users.togo-gt = {
    isNormalUser = true;
    description = "Togo-GT";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
      "libvirtd"
      "vboxusers"
      "syncthing"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzs4vJf1MW9Go0FzrBlUuqwwYDyDG7kP5KQYkxSplxF michael.kaare.nielsen@gmail.com"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = "100000000";
    auto-optimise-store = true;
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
    cores = 0;
    max-jobs = "auto";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.fstrim.enable = true;

  services.earlyoom.enable = true;

  services.flatpak.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  services.hardware.bolt.enable = true;

  services.restic.backups.system = {
    initialize = true;
    repository = "/var/backup";
    passwordFile = "/etc/restic/password";
    paths = [ "/home" "/etc/nixos" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  services.syncthing = {
    enable = true;
    user = "togo-gt";
    dataDir = "/home/togo-gt/Sync";
    configDir = "/home/togo-gt/.config/syncthing";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  services.redis.servers."" = {
    enable = true;
    port = 6379;
  };

  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
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

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    fwupd.enable = true;
    thermald.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      22
      80
      443
      24800
      27015
      27036
      27037
      27016
      27017
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; }
    ];
    allowedUDPPorts = [
      24800
      27031
      27036
      3659
      27015
      27016
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27031; }
      { from = 4380; to = 4380; }
    ];
  };

  security = {
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
  };

  system.stateVersion = "25.05";
}
