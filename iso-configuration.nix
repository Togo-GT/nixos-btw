# iso-configuration.nix - Live ISO configuration
{ config, pkgs, lib, ... }:

{
  # =============================================
  # PACKAGE CONFIGURATION
  # =============================================
  nixpkgs.config.allowUnfree = true;  # Allow NVIDIA drivers

  # =============================================
  # BASIC ISO SETTINGS
  # =============================================
  image.fileName = "my-nixos-live.iso";  # Output ISO filename
  isoImage.volumeID = "NIXOSLIVE";       # Volume label

  # =============================================
  # BOOT CONFIGURATION
  # =============================================
  boot.loader.grub.device = "nodev";  # No physical device for GRUB
  boot.loader.timeout = 10;           # Boot menu timeout

  # Kernel parameters for live environment
  boot.kernelParams = [
    "quiet"
    "splash"
    "nomodeset"  # Disable kernel mode setting for compatibility
  ];

  # =============================================
  # DESKTOP ENVIRONMENT CONFIGURATION
  # =============================================
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];  # NVIDIA drivers

  # SDDM display manager with auto-login
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # KDE Plasma 6 desktop
  services.desktopManager.plasma6.enable = true;

  # Keyboard layout
  services.xserver.xkb.layout = "dk";
  services.xserver.xkb.variant = "nodeadkeys";

  # =============================================
  # HARDWARE CONFIGURATION
  # =============================================
  hardware.graphics.enable = true;

  # NVIDIA graphics support
  hardware.nvidia = {
    modesetting.enable = true;      # Required for Wayland
    powerManagement.enable = false; # Disable for live environment
    nvidiaSettings = true;          # Enable settings utility
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;                   # Use proprietary drivers
  };

  # =============================================
  # NETWORKING CONFIGURATION
  # =============================================
  networking.networkmanager.enable = true;  # Network management
  networking.hostName = "nixos-live";       # Live environment hostname
  networking.firewall.enable = false;       # Disable firewall for testing
  networking.wireless.enable = false;       # Use NetworkManager for WiFi

  # =============================================
  # USER CONFIGURATION
  # =============================================
  users.users.nixos = {
    isNormalUser = true;
    description = "Live ISO User";
    extraGroups = [
      "wheel"           # Sudo access
      "networkmanager"  # Network management
      "video"           # Video hardware access
      "audio"           # Audio hardware access
    ];
    password = "";  # Empty password for convenience
    uid = 1000;
  };

  # Sudo configuration for live environment
  security.sudo.wheelNeedsPassword = false;

  # =============================================
  # PACKAGE INCLUSION
  # =============================================
  imports = [ ./packages.nix ];  # Include all packages

  # =============================================
  # SYSTEM SERVICES FOR LIVE ENVIRONMENT
  # =============================================
  # SSH access for remote administration
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  # Audio services
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Bluetooth support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # =============================================
  # LOCALIZATION AND TIME SETTINGS
  # =============================================
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "da_DK.UTF-8";
  console.keyMap = "dk";

  # =============================================
  # NIX CONFIGURATION FOR LIVE ENVIRONMENT
  # =============================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # =============================================
  # ISO CONTENT AND DOCUMENTATION
  # =============================================
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
        3. Follow the prompts to configure your system

        NETWORKING:
        - Use NetworkManager applet in system tray for WiFi
        - Ethernet should work automatically

        HARDWARE SUPPORT:
        - NVIDIA graphics with proprietary drivers
        - Intel/AMD CPU support
        - Most common hardware should work

        PACKAGES INCLUDED:
        All packages from main system configuration are available
        in this live environment for testing and installation.

        TROUBLESHOOTING:
        - If display issues occur, try: nomodeset kernel parameter
        - Check /var/log/ for system logs
        - Use journalctl for service logs

        Enjoy NixOS!
      '';
      target = "/README.txt";
    }
  ];

  # =============================================
  # SERVICE OPTIMIZATIONS FOR LIVE ENVIRONMENT
  # =============================================
  # Disable unnecessary services for live environment
  services.flatpak.enable = false;
  services.postgresql.enable = false;
  services.redis.servers."".enable = false;
  services.syncthing.enable = false;
  virtualisation.docker.enable = false;
  virtualisation.libvirtd.enable = false;
  virtualisation.virtualbox.host.enable = false;

  # Enable essential services
  services.avahi.enable = true;
  services.fwupd.enable = true;

  # Power management
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;

  # =============================================
  # FONT CONFIGURATION
  # =============================================
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
  ];

  # =============================================
  # SYSTEM STATE VERSION
  # =============================================
  system.stateVersion = "25.05";
}
