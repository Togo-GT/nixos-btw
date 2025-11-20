# environment/shell/zsh.nix - NIXOS SYSTEM VERSION
{ pkgs, ... }:

{
  # ===== BASIC SHELL SETUP =====
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # ===== ZSH CONFIGURATION =====
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    vteIntegration = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git" "sudo" "systemd" "docker" "kubectl" "history"
        "colored-man-pages" "copyfile" "copypath" "dirhistory"
        "web-search" "npm" "yarn" "rust" "python" "golang"
        "pip" "virtualenv" "terraform" "ansible"
      ];
      theme = "agnoster";
    };

    # ===== SHELL ALIASES =====
    shellAliases = {
      # Shell switching
      "switch-to-fish" = "chsh -s ${pkgs.fish}/bin/fish";
      "switch-to-bash" = "chsh -s ${pkgs.bash}/bin/bash";

      # ... keep all your existing aliases ...
    };

    # ===== SHELL INIT =====
    shellInit = ''
      # ===== PERFORMANCE OPTIMIZATIONS =====
      zmodload zsh/zprof
      __zsh_load_start=$((EPOCHREALTIME*1000))

      # ===== ZSH HISTORY CONFIGURATION =====
      HISTSIZE=100000
      SAVEHIST=100000
      HISTFILE="$HOME/.local/state/zsh/history"

      # History behavior options:
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_REDUCE_BLANKS
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY
      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_SAVE_NO_DUPS

      # Create directory for ZSH history file
      mkdir -p "$HOME/.local/state/zsh"

      # ===== DEVELOPMENT ENVIRONMENT =====
      export PIP_REQUIRE_VIRTUALENV=true

      if [ -f "$HOME/.config/python/pythonrc.py" ]; then
        export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"
      fi

      export PYTHONPYCACHEPREFIX="$HOME/.cache/python"
      export PIPX_HOME="$HOME/.local/share/pipx"
      export PIPX_BIN_DIR="$HOME/.local/bin"

      # ===== RUST DEVELOPMENT =====
      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"

      # ===== GO DEVELOPMENT =====
      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"

      # ===== NODE.JS DEVELOPMENT =====
      export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
      export NODE_REPL_HISTORY="$HOME/.local/share/node_repl_history"

      # ===== SECURITY & AUTHENTICATION =====
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      # ===== APPLICATION SPECIFIC SETTINGS =====
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # REMOVED DUPLICATE ENVIRONMENT VARIABLES - they are now set in environment.sessionVariables
      # MOZ_ENABLE_WAYLAND, QT_QPA_PLATFORM, SDL_VIDEODRIVER, _JAVA_AWT_WM_NONREPARENTING
      # EDITOR, VISUAL, PAGER, MANPAGER, BAT_THEME, COLORTERM, NIXOS_CONFIG, NIXOS_FLAKE

      # ===== ENHANCED SHELL FUNCTIONS =====
      # ... keep all your existing functions (home-manager, mkcd, weather, etc.) ...

      # ===== STARTUP MESSAGES =====
      __zsh_load_end=$((EPOCHREALTIME*1000))
      export ZSH_LOAD_TIME=$((__zsh_load_end - __zsh_load_start))

      if [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH ($(hostname -I | awk '{print $1}'))"
      fi

      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh" 2>/dev/null && echo "📁 Loaded local ZSH configuration" || echo "⚠️  Local ZSH config not found"
      fi

      if [ -z "$TMUX" ] && [ -t 1 ]; then
        echo ""
        echo "🌟 NixOS ZSH Ultra Configuration v2.0"
        echo "💡 Type 'nix-help' for useful commands"
        echo "⚡ ZSH loaded in ''${ZSH_LOAD_TIME}ms"
        echo "🐚 Other shells: 'switch-to-fish' or 'switch-to-bash'"
        echo ""
      fi
    '';
  };
}
