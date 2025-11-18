# /home/togo-gt/nixos-config/flake.nix - FIXED VERSION
{
  description = "NixOS system configuration for togo-gt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      "togo-gt" = lib.nixosSystem {
        inherit system;
        modules = [
        # User
          ./user/togo-gt/hardware-configuration.nix
          ./user/togo-gt/configuration.nix
        # Environment
          ./environment/zsh-fix.nix
          ./environment/default.nix


          nixos-hardware.nixosModules.common-gpu-nvidia

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.togo-gt = import ./user/togo-gt/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      "nixos-live" = lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./environment/iso-configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "togo-gt" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./user/togo-gt/home.nix
          {
            home = {
              username = "togo-gt";
              homeDirectory = "/home/togo-gt";
              stateVersion = "25.05";
            };
          }
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };

    # Devshell for easy development
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nixpkgs-fmt
        statix
        alejandra
        git
      ];
    };
  };
}
