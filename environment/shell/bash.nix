# environment/shell/bash.nix (FIXED VERSION)
{ pkgs, ... }:

{
  # ===== BASH CONFIGURATION =====
  programs.bash.enable = true;

  # BASH INIT FOR ALL USERS (system-wide)
  environment.interactiveShellInit = ''
    # History settings
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export HISTCONTROL=ignoredups:erasedups

    # XDG Base Directory
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"

    # Development paths
    export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"

    # Docker completions if available
    if [ -f ${pkgs.docker}/share/bash-completion/completions/docker ]; then
        source ${pkgs.docker}/share/bash-completion/completions/docker
    fi

    # Welcome message
    if [ -z "$TMUX" ] && [ -t 1 ]; then
      echo "🐚 Bash shell on NixOS"
      echo "💡 Bash is available as fallback shell"
    fi
  '';

  # BASH ALIASES (system-wide)
  environment.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "ll" = "ls -la";
    "la" = "ls -A";

    # Safety
    "rm" = "rm -i";
    "cp" = "cp -i";
    "mv" = "mv -i";

    # NixOS
    "nix-update" = "sudo nixos-rebuild switch --flake \"/home/togo-gt/nixos-config#togo-gt\"";
    "nix-search" = "nix search nixpkgs";
  };
}
