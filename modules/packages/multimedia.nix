# =====================================
# MULTIMEDIA APPLICATIONS CONFIGURATION
# =====================================
{ config, pkgs, ... }:

let
  mediaPackages = with pkgs; [
    # =====================================
    # MEDIA PLAYERS AND EDITORS
    # =====================================
    audacity   # Audio editing and recording software
    handbrake  # Video transcoder
    mpv        # Command-line media player
    spotify    # Music streaming service
    vlc        # Cross-platform media player

    # =====================================
    # GRAPHICS AND DOCUMENT EDITING
    # =====================================
    gimp     # GNU Image Manipulation Program
    inkscape # Vector graphics editor
    krita    # Digital painting and illustration software
  ];
in {
  environment.systemPackages = mediaPackages;
}
