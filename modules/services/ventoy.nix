{ pkgs, config, lib, ... }:

let
  ventoyPkg = if pkgs.unstable ? ventoy then pkgs.unstable.ventoy else pkgs.ventoy;
in
{
  options.services.ventoy = {
    enable = lib.mkEnableOption "Ventoy bootable USB utility";
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Autostart Ventoy GUI on desktop login";
    };
  };

  config = lib.mkIf config.services.ventoy.enable {
    environment.systemPackages = [ ventoyPkg ];

    environment.etc."xdg/autostart/ventoy.desktop".text = lib.mkIf config.services.ventoy.autostart ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Ventoy
      Comment=Ventoy GUI
      Exec=${ventoyPkg}/bin/VentoyGUI
      Icon=${ventoyPkg}/share/icons/ventoy.png
      Categories=System;
      Terminal=false
      StartupNotify=false
    '';
  };

}

