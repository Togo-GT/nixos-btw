# =====================================
# SYSTEM SERVICES CONFIGURATION
# =====================================
# Services module: services.nix

{ ... }:
{
  #############################
  # SYSTEM SERVICES
  #############################
  services.fstrim.enable = true;     # Enable periodic SSD TRIM operations
  services.earlyoom.enable = true;   # Early Out-of-Memory killer
  services.flatpak.enable = true;    # Flatpak application support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # =====================================
  # POWER MANAGEMENT
  # =====================================
  # Choose either TLP or power-profiles-daemon
  # TLP selected here due to existing CPU governor settings
  services.power-profiles-daemon.enable = false;  # Disable power-profiles-daemon

  services.tlp = {
    enable = true;  # Enable TLP power management
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";    # Performance mode on AC power
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";     # Powersave mode on battery
    };
  };

  services.avahi.enable = true;      # Zero-configuration networking (mDNS/DNS-SD)
  services.avahi.nssmdns4 = true;    # Enable mDNS hostname resolution
  services.fwupd.enable = true;      # Firmware update service
  services.thermald.enable = true;   # Thermal monitoring and protection

  #############################
  # GAMING PROGRAMS
  #############################
  programs.steam = {
    enable = true;                           # Enable Steam gaming platform
    remotePlay.openFirewall = true;          # Open firewall for Remote Play
    dedicatedServer.openFirewall = true;     # Open firewall for dedicated servers
  };
  programs.gamescope.enable = true;  # SteamOS gamescope compositor
  programs.gamemode.enable = true;   # Game performance optimizer

  #############################
  # HARDWARE SERVICES
  #############################
  services.hardware.bolt.enable = true;  # Thunderbolt 3 device support

  #############################
  # VIRTUALIZATION SERVICES
  #############################
  virtualisation.docker.enable = true;                    # Docker container platform
  virtualisation.docker.rootless.enable = true;           # Rootless Docker mode
  virtualisation.docker.rootless.setSocketVariable = true; # Set DOCKER_HOST variable

  virtualisation.libvirtd.enable = true;                  # Libvirt virtualization
  virtualisation.libvirtd.qemu.runAsRoot = true;          # Run QEMU as root
  virtualisation.libvirtd.qemu.swtpm.enable = true;       # Software TPM support

  # DBUS is essential for desktop environments
  services.dbus.enable = true;

  # For application discovery
  services.gvfs.enable = true;

  # For removable media
  services.udisks2.enable = true;

  # For power management
  services.upower.enable = true;
}

