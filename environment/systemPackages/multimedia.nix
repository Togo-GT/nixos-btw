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
  # reaper                   # Professional DAW - FJERNET (ikke tilgængelig)
  # bitwig-studio            # Modern DAW - FJERNET (ikke tilgængelig)
  musescore                # Music notation software
  # hydrogen                 # Drum machine/sequencer - FJERNET (ikke tilgængelig)
  # lmms                     # Linux MultiMedia Studio - FJERNET (ikke tilgængelig)

  # ===== VIDEO PRODUCTION =====
  obs-studio               # Live streaming/recording
  kdePackages.kdenlive     # Video editor
  blender                  # 3D creation suite
  shotcut                  # Cross-platform video editor
  # olive-editor             # Non-linear video editor - FJERNET (ikke tilgængelig)
  # davinci-resolve          # Professional video editing - FJERNET (ikke tilgængelig)
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
