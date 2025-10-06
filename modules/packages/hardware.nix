# =====================================
# HARDWARE TOOLS CONFIGURATION
# =====================================
{ pkgs, ... }:

let
  hardwarePackages = with pkgs; [
    # =====================================
    # GPU AND GRAPHICS
    # =====================================
    clinfo               # OpenCL information utility
    glxinfo              # OpenGL information utility
    vulkan-loader        # Vulkan loading library
    vulkan-tools         # Vulkan utilities including vkcube and vulkaninfo
    nvidia-vaapi-driver  # VA-API implementation using NVIDIA NVDEC

    # =====================================
    # HARDWARE INFORMATION
    # =====================================
    dmidecode  # DMI/SMBIOS table reader
    inxi       # Full featured system information script
    pciutils   # PCI bus utilities (lspci)

    # =====================================
    # STORAGE
    # =====================================
    smartmontools  # S.M.A.R.T. monitoring tools
    ntfs3g         # NTFS filesystem driver with read/write support

    # =====================================
    # GAMING PERFORMANCE
    # =====================================
    gamemode  # Optimize system performance for games
    mangohud  # Vulkan/OpenGL overlay for monitoring FPS, temps, etc.

    # =====================================
    # SYSTEM LIBRARIES
    # =====================================
    libnotify    # Desktop notification library
    libva-utils  # VA-API (Video Acceleration) utilities

    # =====================================
    # HARDWARE CONTROL
    # =====================================
    brightnessctl  # Backlight brightness control
    acpid          # ACPI event daemon for power management

    # =====================================
    # NVIDIA TOOLS
    # =====================================
    nvtopPackages.nvidia    # GPU process monitoring for NVIDIA GPUs
    cudaPackages.cudatoolkit  # NVIDIA CUDA development toolkit

    # =====================================
    # INPUT HANDLING
    # =====================================
    xorg.xkbcomp  # XKB keymap compiler
  ];
in {
  environment.systemPackages = hardwarePackages;
}
