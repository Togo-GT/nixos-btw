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
    package = config.boot.kernelPackages.nvidiaPackages.beta;  # ← CHANGE TO BETA

    # =====================================
    # PRIME RENDERING (OPTIMUS TECHNOLOGY)
    # =====================================
    prime = {
      sync.enable = true;            # Enable PRIME sync for Optimus laptops
      intelBusId = "PCI:0:2:0";      # PCI bus ID for Intel integrated graphics
      nvidiaBusId = "PCI:1:0:0";     # PCI bus ID for NVIDIA dedicated graphics
    };
  };

  # Rest of your configuration remains the same...
  hardware.cpu.intel.updateMicrocode = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  programs.dconf.enable = true;
}
