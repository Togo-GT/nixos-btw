{ pkgs, lib, ... }:

with pkgs; [
  # ===== MULTIMEDIA FOUNDATION =====
  ffmpeg                   # Audio/video processing
  mpv                      # Video player
  vlc                      # |* Cross-platform media player *|
  imagemagick              # Image manipulation CLI

  # ===== AUDIO PRODUCTION =====
  audacity                 # Audio editor and recorder
  tenacity                 # Audacity fork
  ardour                   # |* Digital audio workstation *|
  reaper                   # |* Professional DAW *|
  bitwig-studio            # Modern DAW
  musescore                # Music notation software
  hydrogen                 # |* Drum machine/sequencer *|
  lmms                     # |* Linux MultiMedia Studio *|

  # ===== VIDEO PRODUCTION =====
  obs-studio               # |* Live streaming/recording *|
  kdePackages.kdenlive     # |* Video editor *|
  blender                  # 3D creation suite
  shotcut                  # Cross-platform video editor
  olive-editor             # Non-linear video editor
  davinci-resolve          # Professional video editing
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
