# =====================================
# GRAPHICAL ENVIRONMENT CONFIGURATION
# =====================================
# Services module: graphical.nix
{ config, pkgs, ... }:
{
  # =====================================
  # NVIDIA / OPTIMUS CONFIGURATION
  # =====================================
  hardware.nvidia = {
    # Required for Wayland compatibility
    modesetting.enable = true;
    powerManagement.enable = true;
    #-----------------------------
    open = false;                    # Use proprietary drivers (false) vs open-source (true)
    nvidiaSettings = true;           # Enable NVIDIA control panel
    package = config.boot.kernelPackages.nvidiaPackages.stable;  # Use stable NVIDIA drivers

    # =====================================
    # PRIME RENDERING (OPTIMUS TECHNOLOGY)
    # =====================================
    prime = {
      sync.enable = true;            # Enable PRIME sync for Optimus laptops
      intelBusId = "PCI:0:2:0";      # PCI bus ID for Intel integrated graphics
      nvidiaBusId = "PCI:1:0:0";     # PCI bus ID for NVIDIA dedicated graphics
    };
  };

  # =====================================
  # CPU AND MICROCODE UPDATES
  # =====================================
  hardware.cpu.intel.updateMicrocode = true;  # Intel CPU microcode updates for security/stability

  # =====================================
  # GRAPHICS SYSTEM SETTINGS
  # =====================================
  hardware.graphics = {
    enable = true;     # Enable graphics support
    enable32Bit = true; # Enable 32-bit graphics support (for Steam, Wine, etc.)
  };

  # =====================================
  # X SERVER CONFIGURATION
  # =====================================
  services.xserver = {
    enable = true;                   # Enable X11 display server
    videoDrivers = [ "nvidia" ];     # Use NVIDIA graphics drivers
  };

  # =====================================
  # DISPLAY MANAGER (SDDM) CONFIGURATION
  # =====================================
  # Important for Plasma 6 + NVIDIA compatibility
  services.displayManager.sddm = {
    enable = true;                   # Enable SDDM display manager
    wayland.enable = true;           # Enable Wayland session support
  };

  # =====================================
  # DESKTOP ENVIRONMENT (PLASMA 6)
  # =====================================
  services.desktopManager.plasma6.enable = true;  # Enable KDE Plasma 6 desktop

  # =====================================
  # WAYLAND SESSION VARIABLES FOR NVIDIA
  # =====================================
  environment.sessionVariables = {
    # Improve Wayland compatibility with NVIDIA
    GBM_BACKEND = "nvidia-drm";                    # Use NVIDIA as GBM backend
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";          # Force NVIDIA GLX vendor
    # Important to avoid black screens in Wayland
    WLR_NO_HARDWARE_CURSORS = "1";                 # Software cursor rendering
  };

  # =====================================
  # XDG DESKTOP PORTALS
  # =====================================
  # Required for file dialogs, screen sharing, etc.
  xdg.portal = {
    enable = true;  # Enable XDG desktop portals
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde  # KDE portal integration
      xdg-desktop-portal-gtk              # GTK portal integration
    ];
  };

  # =====================================
  # DCONF SUPPORT
  # =====================================
  programs.dconf.enable = true;  # Required for GNOME/KDE configuration storage
}
