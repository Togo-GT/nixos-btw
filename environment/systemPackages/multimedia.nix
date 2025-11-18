{ pkgs }:

with pkgs; [
  # Multimedia - COMPLETE creative suite
  ffmpeg
  mpv
  vlc
  imagemagick

  # Audio production
  audacity
  ardour
  reaper
  bitwig-studio

  # Video production
  obs-studio
  kdePackages.kdenlive
  blender
  shotcut
  olive-editor

  # Graphics & design
  gimp
  inkscape
  krita
]
