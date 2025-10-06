# =====================================
# VENTOY BOOTABLE USB CONFIGURATION
# =====================================
# Services module: ventoy.nix

{ config, pkgs, ... }:
{
  # =====================================
  # VENTOY PACKAGE INSTALLATION
  # =====================================
  environment.systemPackages = with pkgs; [
    unstable.ventoy  # Bootable USB solution from unstable channel
  ];

  # =====================================
  # DESKTOP AUTOSTART CONFIGURATION
  # =====================================
  # Optional - only enable if you want Ventoy to autostart
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # =====================================
  # VENTOY AUTOSTART ENTRY
  # =====================================
  environment.etc."xdg/autostart/ventoy.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Ventoy
    Comment=Ventoy GUI
    Exec=${pkgs.unstable.ventoy-full}/bin/VentoyGUI
    Icon=ventoy
    Categories=System;
    Terminal=false
    StartupNotify=false
  '';
}
