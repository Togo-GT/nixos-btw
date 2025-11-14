# /home/togo-gt/nixos-config/flake.nix - FIXED VERSION
{
  # ===========================================================================
  # FLAKE DOKUMENTATION - SYSTEMETS BLÅPRINT
  # ===========================================================================
  description = "NixOS system configuration for togo-gt";

  # ===========================================================================
  # INPUT DEFINITIONER - SYSTEMETS BYGGESTENENE
  # ===========================================================================
  inputs = {
    # -------------------------------------------------------------------------
    # NIXOS UNSTABLE - GRUNDSTONEN AF SYSTEMET
    # -------------------------------------------------------------------------
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # -------------------------------------------------------------------------
    # NIXOS HARDWARE - BRUG TIL MASKINENS SJÆL
    # -------------------------------------------------------------------------
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # -------------------------------------------------------------------------
    # HOME MANAGER - BRUGERSPECIFIK KONFIGURATION
    # -------------------------------------------------------------------------
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # ===========================================================================
  # OUTPUT DEFINITIONER - SYSTEMETS FÆRDIGE UNIVERS
  # ===========================================================================
  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs: {
    # =========================================================================
    # NIXOS KONFIGURATIONER - SYSTEMETS MULTIVERSE
    # =========================================================================
    nixosConfigurations = {
      # -----------------------------------------------------------------------
      # TOGO-GT SYSTEMDEFINITION - PRIMARY PERSONLIGE ARBEJDSSTATION
      # -----------------------------------------------------------------------
      "togo-gt" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # =====================================================================
        # MODULER - SYSTEMETS ORGANSYSTEMER
        # =====================================================================
        modules = [
          # -------------------------------------------------------------------
          # HOVEDKONFIGURATIONER
          # -------------------------------------------------------------------
          ./configuration.nix
          ./zsh-fix.nix
          ./packages.nix

          # -------------------------------------------------------------------
          # HARDWARE-KONFIGURATIONER
          # -------------------------------------------------------------------
          ./hardware-configuration.nix
          nixos-hardware.nixosModules.common-gpu-nvidia

          # -------------------------------------------------------------------
          # HOME MANAGER INTEGRATION
          # -------------------------------------------------------------------
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.togo-gt = import ./home.nix;

            # Import the same nixpkgs for consistency
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # -----------------------------------------------------------------------
      # NIXOS-LIVE ISO SYSTEM - SEPARAT KONFIGURATION
      # -----------------------------------------------------------------------
      "nixos-live" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./iso-configuration.nix
        ];
      };
    };
  };
}
