# environment/default.nix

{ pkgs, lib, ... }:

let
  variables = import ./variables.nix { inherit pkgs lib; };
  nixpkgs = import ./nixpkgs.nix { inherit pkgs lib; };
  systemPackages = let
    all = import ./all.nix { inherit pkgs lib; };
  # optional = import ./optional.nix { inherit pkgs lib; };

  in
    lib.lists.unique (
                      all
#                     optional
);
in
{
  imports = [ ./zsh.nix ];
  environment.systemPackages = systemPackages;
  environment.variables = variables;
  environment.nixpkgs = nixpkgs;
  }
