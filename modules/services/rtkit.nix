# =====================================
# REALTIME KIT CONFIGURATION
# =====================================
# Services module: rtkit.nix
{ config, pkgs, lib, ... }:
{
  # =====================================
  # REALTIME PRIVILEGES FOR AUDIO
  # =====================================
  security.rtkit.enable = true;  # Enable RealtimeKit for audio applications
}
