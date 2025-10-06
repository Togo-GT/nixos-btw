# =====================================
# VENTOY BOOTABLE USB CONFIGURATION
# =====================================
# Services module: ventoy.nix

{ pkgs, lib, ... }:

let
  ventoyPkg = with pkgs;
    let
      stableVentoy = ventoy or null;
      unstableVentoy = (unstable or {}).ventoy or null;
    in
    if stableVentoy != null then stableVentoy
    else if unstableVentoy != null then unstableVentoy
    else throw "Ventoy package not found in stable or unstable channels";

in {
  options.services.ventoy = {
    enable = lib.mkEnableOption "Ventoy bootable USB utility";
    package = lib.mkOption {
      type = lib.types.package;
      default = ventoyPkg;
      description = "Ventoy package to use";
    };
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Autostart Ventoy GUI on desktop login";
    };
  };

  config = let
    enabled = builtins.tryEval (config.services.ventoy.enable or false);
    autostart = builtins.tryEval (config.services.ventoy.autostart or false);
    pkg = builtins.tryEval (config.services.ventoy.package or ventoyPkg);
  in lib.mkIf enabled.value {
    environment.systemPackages = [ pkg.value ];

    services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkIf autostart.value
      (lib.mkDefault true);

    environment.etc."xdg/autostart/ventoy.desktop" = lib.mkIf autostart.value {
      text = ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Ventoy
        Comment=Ventoy GUI
        Exec=${pkg.value}/bin/VentoyGUI
        Icon=ventoy
        Categories=System;
        Terminal=false
        StartupNotify=false
      '';
    };
  };
}
