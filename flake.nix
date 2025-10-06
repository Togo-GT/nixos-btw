# /home/togo-gt/nixos-btw/flake.nix
{
  description = "NixOS flake with modular system + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      inherit system;

      # Pass inputs to all modules
      specialArgs = { inherit inputs unstable; };

      modules = [
        # Import the overlay from separate file
        {
         # nixpkgs.overlays = [ (import ./nixos/overlays/ventoy.nix inputs) ];
        }

        ./hosts/nixos-btw/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs pkgs; };

          home-manager.users.togo-gt = {
            home.stateVersion = "25.05";
          };
        }
      ];
    };
  };
}
