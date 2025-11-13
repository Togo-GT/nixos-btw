# flake.nix - Nix flake configuration
{
  # =============================================
  # FLAKE METADATA AND DESCRIPTION
  # =============================================
  description = "NixOS system configuration for togo-gt";

  # =============================================
  # INPUT DEFINITIONS - DEPENDENCY SOURCES
  # =============================================
  inputs = {
    # NixOS unstable channel - latest packages and features
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware-specific configurations and profiles
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # =============================================
  # OUTPUT DEFINITIONS - SYSTEM CONFIGURATIONS
  # =============================================
  outputs = { self, nixpkgs, nixos-hardware }: {

    # NixOS system configurations
    nixosConfigurations = {

      # Primary system configuration for togo-gt workstation
      "togo-gt" = nixpkgs.lib.nixosSystem {
        # System architecture
        system = "x86_64-linux";

        # Configuration modules to include
        modules = [
          # Main system configuration
          ./configuration.nix

          # ZSH shell configuration
          ./zsh-fix.nix

          # Package collection
          ./packages.nix

          # Hardware-specific configuration
          ./hardware-configuration.nix

          # NVIDIA hardware support module
          nixos-hardware.nixosModules.common-gpu-nvidia
        ];
      };

      # Live ISO configuration for installation and recovery
      "nixos-live" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Minimal installation CD base
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

          # Custom ISO configuration
          ./iso-configuration.nix
        ];
      };
    };
  };
}
