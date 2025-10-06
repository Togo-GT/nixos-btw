# =====================================
# INTERNATIONALIZATION CONFIGURATION
# =====================================
# Misc module: i18n.nix

{ config, pkgs, lib, ... }:
{
  # =====================================
  # TIMEZONE CONFIGURATION
  # =====================================
  time.timeZone = "Europe/Copenhagen";  # Set system timezone to Denmark

  # =====================================
  # NETWORK TIME SYNCHRONIZATION
  # =====================================
  services.timesyncd = {
    enable = true;  # Enable systemd-timesyncd for time synchronization
    servers = [
      "0.dk.pool.ntp.org"  # Danish NTP server pool
      "1.dk.pool.ntp.org"
      "2.dk.pool.ntp.org"
      "3.dk.pool.ntp.org"
    ];
  };

  # =====================================
  # LOCALE AND LANGUAGE SETTINGS
  # =====================================
  i18n.defaultLocale = lib.mkForce "da_DK.UTF-8";  # Force Danish as default locale
  i18n.supportedLocales = [
    "da_DK.UTF-8/UTF-8"  # Danish locale support
    "en_DK.UTF-8/UTF-8"  # English (Denmark) locale support
  ];

  # =====================================
  # LOCALE ENVIRONMENT VARIABLES
  # =====================================
  i18n.extraLocaleSettings = {
    LANG = "da_DK.UTF-8";              # Default language
    LC_CTYPE = "da_DK.UTF-8";          # Character classification
    LC_NUMERIC = "da_DK.UTF-8";        # Number formatting
    LC_TIME = "da_DK.UTF-8";           # Date and time formatting
    LC_MONETARY = "da_DK.UTF-8";       # Currency formatting
    LC_ADDRESS = "da_DK.UTF-8";        # Address formatting
    LC_IDENTIFICATION = "da_DK.UTF-8"; # Metadata about locale
    LC_MEASUREMENT = "da_DK.UTF-8";    # Measurement units
    LC_PAPER = "da_DK.UTF-8";          # Paper size standards
    LC_TELEPHONE = "da_DK.UTF-8";      # Telephone number formatting
    LC_NAME = "da_DK.UTF-8";           # Name formatting
  };

  # =====================================
  # KEYBOARD LAYOUT CONFIGURATION
  # =====================================
  services.xserver.xkb = {
    layout = "dk";    # Danish keyboard layout for X11
    variant = "";     # No keyboard variant
  };

  console.keyMap = "dk-latin1";  # Danish keyboard layout for console
}
