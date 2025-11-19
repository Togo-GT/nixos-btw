# environment/systemPackages/optional.nix
{ pkgs, lib }:

let
  cli = import ./cli.nix { inherit pkgs lib; };
  dev = import ./dev.nix { inherit pkgs lib; };
  gui = import ./gui.nix { inherit pkgs lib; };
  gaming = import ./gaming.nix { inherit pkgs lib; };
  multimedia = import ./multimedia.nix { inherit pkgs lib; };
  system = import ./system.nix { inherit pkgs lib; };
in
# Remove any duplicates that might overlap with essentials
lib.lists.unique (cli ++ dev ++ gui ++ gaming ++ multimedia ++ system)
