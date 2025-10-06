# =====================================
# PRINTING SERVICE CONFIGURATION
# =====================================
# Services module: printing.nix
{ config, pkgs, lib, ... }:
{
  # =====================================
  # CUPS PRINTING SERVICE
  # =====================================
  services.printing.enable = true;  # Enable CUPS printing service
}
