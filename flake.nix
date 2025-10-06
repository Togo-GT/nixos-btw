{
  description = "NixOS flake with modular system + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/nixos-btw/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs pkgs; };

          home-manager.users.togo-gt = {
            imports = [ ./home.nix ];  # ✅ CORRECTED path - points to your home.nix file
          };
        }
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
