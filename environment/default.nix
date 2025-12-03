# environment/default.nix
#
# Main environment configuration module
# This module aggregates all environment-related settings including:
# - System packages
# - Shell configurations
# - Environment variables
# - Nixpkgs configuration
# - Rate limiting settings

{ pkgs, lib, ... }:

let
  # Import nixpkgs configuration from separate file
  # This allows for centralized package configuration
  nixpkgsConfig = import ./nixpkgs.nix;

  # Aggregate system packages from various sources
  # The 'all.nix' file contains the base set of packages
  allPackages = import ./all.nix { inherit pkgs lib; };
  #                    ./optional.nix

  # Remove any duplicate packages to ensure clean installation
  systemPackages = lib.lists.unique allPackages;

in
{
  # Import sub-modules for modular configuration
  imports = [
    # Shell configuration (bash, zsh, fish, etc.)
    ./shell/default.nix

    # System-wide environment variables
    ./variables.nix

    # Rate limiting for network services
    ./rate-limiting.nix
    # Language Server Protocol
    ./lsp.nix
  ];

  # System-wide packages available to all users
  # These are installed in the global environment
  environment.systemPackages = systemPackages;

  # Nixpkgs configuration settings
  # Controls package options, overlays, and permitted licenses
  nixpkgs.config = nixpkgsConfig.nixpkgs.config;
}
