# Multimedia packages - audio, video, and graphics production
{ pkgs, lib, ... }:

with pkgs; [
  # ===== MULTIMEDIA FOUNDATION =====
  ffmpeg                   # Audio/video processing
  mpv                      # Video player
  vlc                      # Cross-platform media player
  imagemagick              # Image manipulation CLI

  # ===== AUDIO PRODUCTION =====
  audacity                 # Audio editor and recorder
  tenacity                 # Audacity fork
  ardour                   # Digital audio workstation
  musescore                # Music notation software

  # ===== VIDEO PRODUCTION =====
  obs-studio               # Live streaming/recording
  kdePackages.kdenlive     # Video editor
  blender                  # 3D creation suite
  shotcut                  # Cross-platform video editor
  handbrake                # Video transcoder
  mkvtoolnix               # Matroska (MKV) tools

  # ===== GRAPHICS & DESIGN =====
  gimp                     # GNU Image Manipulation Program
  inkscape                 # Vector graphics editor
  krita                    # Digital painting studio
  darktable                # Photography workflow application
  rawtherapee              # Raw image processing
  scribus                  # Desktop publishing
]
