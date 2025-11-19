# environment/systemPackages/default.nix
{ pkgs, lib }:

let
  core = import ./core.nix { inherit pkgs lib; };
  cli = import ./cli.nix { inherit pkgs lib; };
  dev = import ./dev.nix { inherit pkgs lib; };
  gui = import ./gui.nix { inherit pkgs lib; };
  gaming = import ./gaming.nix { inherit pkgs lib; };
  multimedia = import ./multimedia.nix { inherit pkgs lib; };
  system = import ./system.nix { inherit pkgs lib; };
in

# Combine all package sets, removing duplicates
lib.unique (core ++ cli ++ dev ++ gui ++ gaming ++ multimedia ++ system)
