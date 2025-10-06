# =====================================
# NETWORKING CONFIGURATION
# =====================================
# System module: networking.nix

{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = "nixos-btw";              # System hostname
    networkmanager.enable = true;        # Enable NetworkManager for network management
  };
}
