# environment/default.nix
{ pkgs, lib, ... }:

let
  nixpkgsConfig = import ./nixpkgs.nix;
  systemPackages = let
    all = import ./all.nix { inherit pkgs lib; };
 #   optional = import ./optional.nix { inherit pkgs lib; };
  in
    lib.lists.unique (
      all
 #     optional
    );
in
{
  imports = [
    ./shell/default.nix
    ./variables.nix  # This imports the module properly
  ];

  environment.systemPackages = systemPackages;
  nixpkgs.config = nixpkgsConfig.nixpkgs.config;

  # REMOVE this line - it's causing the conflict:
  # environment.variables = variables;
}
