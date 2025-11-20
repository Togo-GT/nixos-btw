# environment/default.nix

{ pkgs, lib, ... }:

let
  variables = import ./variables.nix { inherit pkgs; };
  nixpkgsConfig = import ./nixpkgs.nix;
  systemPackages = let
    all = import ./all.nix { inherit pkgs lib; }; # or start whit
  # optional = import ./optional.nix { inherit pkgs lib; };

  in
    lib.lists.unique (
                      all # or
#                     optional
);
in
{
  imports = [  ./shell/default.nix ];
  environment.systemPackages = systemPackages;
  environment.variables = variables;
  nixpkgs.config = nixpkgsConfig.nixpkgs.config;
  }
