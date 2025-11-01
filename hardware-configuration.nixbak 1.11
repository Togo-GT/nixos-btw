# =============================================================================
# HARDWARE CONFIGURATION - FIXED VERSION
# NVIDIA PRIME (Intel + NVIDIA) + KDE Plasma 6 (Wayland)
# =============================================================================

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # ---------------------------------------------------------------------------
  # File systems
  # ---------------------------------------------------------------------------
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5a76834c-63d2-4217-90aa-b0a9e5a660e9";
    fsType = "ext4"; # root partition
    options = [ "noatime" "nodiratime" "discard" ]; # SSD optimization
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7193-58DE";
    fsType = "vfat"; # EFI boot partition
    options = [ "fmask=0077" "dmask=0077" ]; # secure permissions
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b4eb1273-3ff3-48e3-9645-b132cc29ba90"; }
  ];

  # ---------------------------------------------------------------------------
  # Kernel & modules
  # ---------------------------------------------------------------------------
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [
    "kvm-intel"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.extraModulePackages = [ pkgs.linuxPackages_latest.nvidiaPackages.stable ];

  boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" ];

  # ---------------------------------------------------------------------------
  # Firmware / CPU
  # ---------------------------------------------------------------------------
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  # ---------------------------------------------------------------------------
  # Graphics - PRIME setup
  # ---------------------------------------------------------------------------
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # ---------------------------------------------------------------------------
  # Input devices
  # ---------------------------------------------------------------------------
  services.libinput.enable = true;

  # ---------------------------------------------------------------------------
  # Power & thermal
  # ---------------------------------------------------------------------------
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;

  # ---------------------------------------------------------------------------
  # Networking hardware
  # ---------------------------------------------------------------------------
  networking.useDHCP = lib.mkDefault true;
}
