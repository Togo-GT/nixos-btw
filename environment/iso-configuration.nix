# iso-configuration.nix - FIXED VERSION
{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # ISO Configuration
  isoImage.isoName = "nixos-live.iso";
  isoImage.volumeID = "NIXOSLIVE";

  # Boot Configuration
  boot = {
    loader.grub.device = "nodev";
    loader.timeout = 10;
    kernelParams = [
      "quiet"
      "splash"
      "nomodeset"
    ];
    supportedFilesystems = [ "ntfs" "btrfs" "ext4" "vfat" ];
  };

  # Desktop Environment
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "nixos";
      };
      defaultSession = "plasma";
    };
    desktopManager.plasma6.enable = true;
    layout = "dk";
    xkbVariant = "";
  };

  # Hardware
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
    };
    bluetooth.enable = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos-live";
    firewall.enable = false;
    wireless.enable = false;
  };

  # Users
  users.users.nixos = {
    isNormalUser = true;
    description = "Live ISO User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    password = ""; # Empty password for live environment
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;

  # Import packages
  imports = [ ./packages.nix ];

  # Services
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    blueman.enable = true;
    avahi.enable = true;
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
  };

  # Disable unnecessary services for live environment
  services.flatpak.enable = false;
  services.postgresql.enable = false;
  services.redis.servers.default.enable = false;
  services.syncthing.enable = false;
  virtualisation.docker.enable = false;
  virtualisation.libvirtd.enable = false;
  virtualisation.virtualbox.host.enable = false;
  services.tlp.enable = false;

  # Locale and Time
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk";

  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    (nerd-fonts.override { fonts = [ "FiraCode" ]; })
  ];

  # ISO Contents
  isoImage.contents = [
    {
      source = pkgs.writeText "README" ''
        NIXOS LIVE ISO WITH KDE PLASMA 6

        Features:
        - KDE Plasma 6 desktop environment
        - NVIDIA graphics support
        - NetworkManager for WiFi and networking
        - Complete package set from main configuration
        - Development tools and utilities
        - Firefox web browser

        User: nixos (no password required)
        Root: no password set (use sudo)

        INSTALLATION:
        1. Open terminal (Konsole)
        2. Run: sudo nixos-install
        3. Follow the prompts

        NETWORKING:
        - Use NetworkManager applet for WiFi
        - Ethernet works automatically

        Enjoy NixOS!
      '';
      target = "/README.txt";
    }
  ];

  system.stateVersion = "25.05";
}
