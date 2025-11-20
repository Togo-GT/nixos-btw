# shell/devshell.nix
{ pkgs, lib, ... }:

let
  optional = import ./optional.nix pkgs lib;
in

pkgs.mkShell {
  name = "nixos-config-dev";

  buildInputs = optional;

  shellHook = ''
    echo "🔧 NixOS Configuration Development Shell"
    echo "📝 Available tools: nixpkgs-fmt, statix, alejandra, nixd, git"
    echo "💡 Run 'nix fmt' to format all Nix files"
    echo "💡 Run 'statix check' to find Nix anti-patterns"
  '';
}
