# shell/devshell.nix
{ pkgs, ... }:

pkgs.mkShell {
  name = "nixos-config-dev";

  packages = with pkgs; [
    # Nix development
    nixpkgs-fmt
    statix
    alejandra
    nixd  # Nix language server

    # Git & version control
    git
    git-lfs

    # General utilities
    jq
    yq-go
    tree
    file

    # Shell utilities
    shellcheck
    shfmt
  ];

  shellHook = ''
    echo "🔧 NixOS Configuration Development Shell"
    echo "📝 Available tools: nixpkgs-fmt, statix, alejandra, nixd, git"
    echo "💡 Run 'nix fmt' to format all Nix files"
    echo "💡 Run 'statix check' to find Nix anti-patterns"
  '';
}
