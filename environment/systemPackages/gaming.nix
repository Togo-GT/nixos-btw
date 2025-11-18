{ pkgs, ... }:

with pkgs; [
  # Gaming - COMPLETE gaming setup
  steam
  heroic
  lutris
  bottles
  playonlinux
  minigalaxy

  # Wine & compatibility
  wine
  wineWowPackages.stable
  winetricks
  protontricks

  # Gaming performance tools
  mangohud
  goverlay
  gamemode
  dxvk

  # Emulators - ALL emulators!
  retroarch
  pcsx2
  dolphin-emu

]
