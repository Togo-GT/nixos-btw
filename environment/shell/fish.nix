# environment/shell/fish.nix - Enhanced Fish configuration
{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Fish-specific aliases
    shellAliases = {
      # Shell switching
      "switch-to-zsh" = "chsh -s ${pkgs.zsh}/bin/zsh";
      "switch-to-bash" = "chsh -s ${pkgs.bash}/bin/bash";

      # Navigation (consistent with other shells)
      ".." = "cd ..";
      "..." = "cd ../..";
      "ll" = "ls -la";
      "la" = "ls -A";

      # NixOS
      "nix-update" = "sudo nixos-rebuild switch --flake \"/home/togo-gt/nixos-config#togo-gt\"";
      "nix-search" = "nix search nixpkgs";
    };

    shellInit = ''
      # Fish-specific optimizations
      set -gx PIP_REQUIRE_VIRTUALENV true
      set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

      # Development environment
      set -gx RUSTUP_HOME "$HOME/.rustup"
      set -gx CARGO_HOME "$HOME/.cargo"
      set -gx GOPATH "$HOME/go"
      set -gx GOBIN "$GOPATH/bin"
      set -gx PIPX_HOME "$HOME/.local/share/pipx"
      set -gx PIPX_BIN_DIR "$HOME/.local/bin"

      # Security & Authentication
      set -gx GPG_TTY (tty)
      set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

      if status is-interactive
        echo "🐟 Fish shell on NixOS"
        echo "💡 Other shells: 'switch-to-zsh' or 'switch-to-bash'"
      end
    '';
  };
}
