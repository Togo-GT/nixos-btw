# environment/optional.nix

{ pkgs, lib }:

let
#  core = import ./systemPackages/core.nix { inherit pkgs lib; };
#  cli = import ./systemPackages/cli.nix { inherit pkgs lib; };
#  dev = import ./dev.nix { inherit pkgs lib; };
#  gui = import ./gui.nix { inherit pkgs lib; };
#  gaming = import ./gaming.nix { inherit pkgs lib; };
#  multimedia = import ./multimedia.nix { inherit pkgs lib; };
#  system = import ./systemPackages/system.nix { inherit pkgs lib; };
  essential = import ./systemPackages/essential.nix { inherit pkgs lib; };

in

# Combine all package sets, removing duplicates
lib.lists.unique (
                  essential # or
#              ++ core
#              ++ cli
#              ++ dev
#              ++ gui
#              ++ gaming
#              ++ multimedia
#              ++ system

               )
