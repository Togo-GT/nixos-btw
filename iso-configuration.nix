# /etc/nixos/iso-configuration.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];

  # ===========================================================================
  # BASIC ISO CONFIGURATION
  # ===========================================================================

  # ISO settings - use new option name
  image.fileName = "my-nixos-live.iso";
  isoImage.volumeID = "NIXOSLIVE";

  # Boot configuration
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  # ===========================================================================
  # DESKTOP ENVIRONMENT (UPDATED OPTION NAMES)
  # ===========================================================================

  services.xserver.enable = true;

  # Use updated option names
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Your keyboard layout
  services.xserver.xkb.layout = "dk";
  services.xserver.xkb.variant = "nodeadkeys";

  # ===========================================================================
  # HARDWARE CONFIGURATION (UPDATED OPTION NAMES)
  # ===========================================================================

  # Use new graphics option name
  hardware.graphics.enable = true;

  # NVIDIA support
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ===========================================================================
  # NETWORKING
  # ===========================================================================

  networking.networkmanager.enable = true;
  networking.hostName = "nixos-live";
  networking.firewall.enable = false; # Disable firewall for live environment

  # ===========================================================================
  # USER CONFIGURATION (FIXED PASSWORD CONFLICT)
  # ===========================================================================

  # Auto-login for convenience - use new option name
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # Live user - FIXED: Only use ONE password method
  users.users.nixos = {
    isNormalUser = true;
    description = "Live ISO User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    password = ""; # Empty password - use ONLY this one
    uid = 1000;
  };

  # Enable sudo without password for live environment
  security.sudo.wheelNeedsPassword = false;

  # ===========================================================================
  # ESSENTIAL PACKAGES (FIXED PACKAGE NAMES)
  # ===========================================================================

  environment.systemPackages = with pkgs; [
    # System tools
    vim htop wget curl git
    pciutils usbutils lm_sensors
    file tree ripgrep fd

    # Disk utilities (FIXED package names)
    gparted gnome-disk-utility    # FIXED: Use top-level gnome-disk-utility
    gptfdisk f2fs-tools btrfs-progs   # FIXED: gptfdisk instead of gdisk
    ntfs3g dosfstools e2fsprogs

    # Network tools (FIXED package names)
    networkmanagerapplet wpa_supplicant
    iw bind                           # FIXED: bind instead of bind.dnsutils

    # Hardware tools
    lshw dmidecode

    # KDE applications
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.kate

    # Browsers
    firefox

    # Development
    gcc gnumake python3 nodejs

    # Nix tools
    nixos-install-tools

    # Audio
    pulsemixer pavucontrol alsa-utils

    # NVIDIA tools
    glxinfo vulkan-tools mesa-demos
  ];

  # ===========================================================================
  # SERVICES
  # ===========================================================================

  # Enable SSH
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ===========================================================================
  # LOCALE AND TIME
  # ===========================================================================

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "da_DK.UTF-8";
  console.keyMap = "dk";

  # ===========================================================================
  # ISO OPTIMIZATIONS
  # ===========================================================================

  # Include a README
  isoImage.contents = [
    {
      source = pkgs.writeText "README" ''
        NixOS Live ISO with KDE Plasma 6

        Features:
        - KDE Plasma 6 desktop
        - NVIDIA PRIME support
        - NetworkManager for WiFi
        - Essential installation tools

        User: nixos (no password)
        Root: no password set

        To install: run 'nixos-install'
      '';
      target = "/README.txt";
    }
  ];
}
