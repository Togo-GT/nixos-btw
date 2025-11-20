# environment/systemPackages/all.nix

{ pkgs, lib }:

let
  core = import ./systemPackages/core.nix { inherit pkgs lib; };
  cli = import ./systemPackages/cli.nix { inherit pkgs lib; };
  dev = import ./systemPackages/dev.nix { inherit pkgs lib; };
  gui = import ./systemPackages/gui.nix { inherit pkgs lib; };
  gaming = import ./systemPackages/gaming.nix { inherit pkgs lib; };
  multimedia = import ./systemPackages/multimedia.nix { inherit pkgs lib; };
  system = import ./systemPackages/system.nix { inherit pkgs lib; };
  essential = import ./systemPackages/essential.nix { inherit pkgs lib; };
in

# Combine all package sets, removing duplicates
lib.lists.unique (
                  core
               ++ cli
               ++ dev
               ++ gui
               ++ gaming
               ++ multimedia
               ++ system
               ++ essential
               )
