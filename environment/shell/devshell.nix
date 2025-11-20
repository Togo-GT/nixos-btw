# shell/devshell.nix
{ pkgs,lib, ... }:

pkgs.mkShell {
  name = "nixos-config-dev";

 optional = import ./optional.nix { inherit pkgs lib; };

  shellHook = ''
    echo "🔧 NixOS Configuration Development Shell"
    echo "📝 Available tools: nixpkgs-fmt, statix, alejandra, nixd, git"
    echo "💡 Run 'nix fmt' to format all Nix files"
    echo "💡 Run 'statix check' to find Nix anti-patterns"
  '';
}
