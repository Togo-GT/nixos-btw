# =====================================
# BOOTLOADER AND KERNEL CONFIGURATION
# =====================================
# System module: boot.nix

{  pkgs, ... }:
{
  boot = {
    # =====================================
    # BOOTLOADER CONFIGURATION
    # =====================================
    # Alternative GRUB configuration (commented out):
    #  boot.loader.grub.enable = true;
    #  boot.loader.grub.version = 2;
    #  boot.loader.grub.device        = "/dev/sda";

    loader.systemd-boot.enable = true;        # Use systemd-boot as bootloader
    loader.efi.canTouchEfiVariables = true;   # Allow modifying EFI variables
    kernelPackages = pkgs.linuxPackages_latest;  # Use latest available kernel

    # =====================================
    # KERNEL PARAMETERS
    # =====================================
    kernelParams = [
      "quiet"                   # Suppress boot messages
      "splash"                  # Enable boot splash screen
      "nvidia-drm.modeset=1"    # Enable NVIDIA DRM kernel mode setting
      "nowatchdog"              # Disable hardware watchdog
      "tsc=reliable"            # Mark TSC as reliable clock source
      "nohibernate"             # Disable hibernation
      "nvreg_EnableMSI=1"       # Enable MSI interrupts for NVIDIA
    ];

    # =====================================
    # INITRD KERNEL MODULES
    # =====================================
    # Modules available in initial ramdisk
    initrd.availableKernelModules = [
      "nvme"          # NVMe SSD support
      "xhci_pci"      # USB 3.0 controller support
      "ahci"          # SATA controller support
      "usbhid"        # USB human interface devices
      "usb_storage"   # USB storage devices
      "sd_mod"        # SCSI disk support
    ];

    # =====================================
    # KERNEL MODULES TO LOAD
    # =====================================
    kernelModules = [
      "fuse"           # Filesystem in Userspace
      "v4l2loopback"   # Virtual video loopback device
      "snd-aloop"      # Audio loopback device
      "nvidia"         # NVIDIA graphics driver
      "nvidia_modeset" # NVIDIA display mode setting
      "nvidia_uvm"     # NVIDIA Unified Memory
      "nvidia_drm"     # NVIDIA DRM driver
    ];
  };
}
