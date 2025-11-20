# environment/shell/bash.nix (FIXED VERSION)
{ pkgs, ... }:

{
  # ===== BASH CONFIGURATION =====
  programs.bash.enable = true;

  # BASH INIT FOR ALL USERS (system-wide)
  environment.interactiveShellInit = ''
    # Performance tracking
    __bash_load_start=$(date +%s%3N)

    # History settings
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export HISTCONTROL=ignoredups:erasedups

    # XDG Base Directory
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"

    # Development paths (system-wide - removed from zsh.nix)
    export PATH="$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$PATH"

    # Docker completions if available
    if [ -f ${pkgs.docker}/share/bash-completion/completions/docker ]; then
        source ${pkgs.docker}/share/bash-completion/completions/docker
    fi

    # Performance tracking end
    __bash_load_end=$(date +%s%3N)
    export BASH_LOAD_TIME=$((__bash_load_end - __bash_load_start))

    # Welcome message
    if [ -z "$TMUX" ] && [ -t 1 ]; then
      echo "🐚 Bash shell on NixOS"
      echo "💡 Bash is available as fallback shell"
      echo "⚡ Bash loaded in ''${BASH_LOAD_TIME}ms"
      echo "🐚 Other shells: 'switch-to-zsh' or 'switch-to-fish'"
    fi
  '';

  # BASH ALIASES (system-wide)
  environment.shellAliases = {
    # Shell switching
    "switch-to-zsh" = "chsh -s ${pkgs.zsh}/bin/zsh";
    "switch-to-fish" = "chsh -s ${pkgs.fish}/bin/fish";

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
