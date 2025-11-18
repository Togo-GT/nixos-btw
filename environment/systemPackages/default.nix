{ pkgs }:

let
  # Import all package categories
  core = import ./core.nix { inherit pkgs; };
  cli = import ./cli.nix { inherit pkgs; };
  dev = import ./dev.nix { inherit pkgs; };
  gui = import ./gui.nix { inherit pkgs; };
  gaming = import ./gaming.nix { inherit pkgs; };
  multimedia = import ./multimedia.nix { inherit pkgs; };
  system = import ./system.nix { inherit pkgs; };
in

# Combine ALL packages (remove duplicates automatically)
lib.removeDuplicates (core ++ cli ++ dev ++ gui ++ gaming ++ multimedia ++ system)
