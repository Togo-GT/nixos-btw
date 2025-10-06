# =====================================
# GUI APPLICATIONS CONFIGURATION
# =====================================
{ pkgs, ... }:

let
  guiPackages = with pkgs; [
    # =====================================
    # BROWSERS AND COMMUNICATION
    # =====================================
    chromium          # Open-source version of Chrome browser
    firefox           # Firefox web browser
    signal-desktop    # Secure messaging app
    telegram-desktop  # Telegram messaging client
    thunderbird       # Email client

    # =====================================
    # DOCUMENT VIEWERS
    # =====================================
    kdePackages.okular  # KDE document viewer (PDF, PS, etc.)
    zathura            # Minimalistic document viewer with vim-like controls
    evince             # GNOME document viewer

    # =====================================
    # SYSTEM TOOLS (GUI)
    # =====================================
    distrobox             # Use any Linux distribution inside your terminal
    kdePackages.dolphin   # KDE file manager
    feh                   # Lightweight image viewer
    gparted               # Partition editor
    kdePackages.konsole   # KDE terminal emulator
    obs-studio           # Streaming and recording software
    paprefs              # PulseAudio preferences
    protonup-qt          # Proton-GE and Wine-GE manager
    transmission_3-gtk   # BitTorrent client (GTK version)

    # =====================================
    # GAMING
    # =====================================
    lutris  # Open gaming platform
    wine    # Windows compatibility layer
  ];
in {
  environment.systemPackages = guiPackages;
}
