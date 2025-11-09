# /etc/nixos/iso-configuration.nix
{ config, pkgs, lib, ... }:

{
  # ===========================================================================
  # ALLOW UNFREE PACKAGES (NVIDIA DRIVERS)
  # ===========================================================================
  nixpkgs.config.allowUnfree = true;

  # ===========================================================================
  # BASIC ISO CONFIGURATION
  # ===========================================================================

  # ISO settings - use new option name
  image.fileName = "my-nixos-live.iso";  # FIXED: isoImage.isoName -> image.fileName
  isoImage.volumeID = "NIXOSLIVE";

  # Boot configuration
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  # Kernel parameters for live environment
  boot.kernelParams = [
    "quiet"
    "splash"
    "nomodeset"
  ];

  # ===========================================================================
  # DESKTOP ENVIRONMENT
  # ===========================================================================

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Display manager with auto-login
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # Desktop environment
  services.desktopManager.plasma6.enable = true;

  # Keyboard layout
  services.xserver.xkb.layout = "dk";
  services.xserver.xkb.variant = "nodeadkeys";

  # ===========================================================================
  # HARDWARE CONFIGURATION
  # ===========================================================================

  hardware.graphics.enable = true;

  # Basic NVIDIA support for live environment
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
  };

  # ===========================================================================
  # NETWORKING
  # ===========================================================================

  networking.networkmanager.enable = true;
  networking.hostName = "nixos-live";
  networking.firewall.enable = false;
  networking.wireless.enable = false;

  # ===========================================================================
  # USER CONFIGURATION
  # ===========================================================================

  # Live user - FIXED: Only use one password method
  users.users.nixos = {
    isNormalUser = true;
    description = "Live ISO User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    password = "";  # Use ONLY this one - remove initialHashedPassword
    uid = 1000;
  };

  # Enable sudo without password for live environment
  security.sudo.wheelNeedsPassword = false;

  # ===========================================================================
  # PACKAGES - IMPORT FROM packages.nix
  # ===========================================================================

  # Import all packages from packages.nix
  imports = [ ./packages.nix ];

  # ===========================================================================
  # SERVICES FOR LIVE ENVIRONMENT
  # ===========================================================================

  # Enable SSH for remote access
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

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ===========================================================================
  # LOCALE AND TIME
  # ===========================================================================

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "da_DK.UTF-8";
  console.keyMap = "dk";

  # ===========================================================================
  # ISO-SPECIFIC OPTIMIZATIONS
  # ===========================================================================

  # Enable flakes in the live environment
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Include a README in the ISO
  isoImage.contents = [
    {
      source = pkgs.writeText "README" ''
        NIXOS LIVE ISO WITH KDE PLASMA 6

        Features:
        - KDE Plasma 6 desktop environment
        - NVIDIA graphics support
        - NetworkManager for WiFi and networking
        - Complete package set from your main configuration
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
        All packages from your main system configuration are available
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

  # ===========================================================================
  # SYSTEM OPTIMIZATIONS FOR LIVE ENVIRONMENT
  # ===========================================================================

  # Disable services that aren't needed in live environment
  services.flatpak.enable = false;
  services.postgresql.enable = false;
  # FIXED: Use new Redis option name
  services.redis.servers."".enable = false;  # services.redis.enable -> services.redis.servers."".enable
  services.syncthing.enable = false;
  virtualisation.docker.enable = false;
  virtualisation.libvirtd.enable = false;
  virtualisation.virtualbox.host.enable = false;

  # Enable essential services only
  services.avahi.enable = true;
  services.fwupd.enable = true;

  # Power management
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;

  # ===========================================================================
  # FONT CONFIGURATION
  # ===========================================================================

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
  ];

  # ===========================================================================
  # SYSTEM STATE VERSION
  # ===========================================================================

  system.stateVersion = "25.05";
}
# sudo nix build .#nixosConfigurations.nixos-live.config.system.build.isoImage --out-link /home/togo-gt/Iso/nixos-live.iso
