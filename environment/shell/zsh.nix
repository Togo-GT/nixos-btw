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

    # ===== ZSH HISTORY CONFIGURATION =====
    histSize = 100000;
    saveHist = 100000;
    histFile = "$HOME/.local/state/zsh/history";

    # ===== SHELL ALIASES =====
    # FLYTT ALLE ALIASES HERIND - DETTE ER DET ENESTE DER SKAL ÆNDRES!
    shellAliases = {
      # Basic navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "~" = "cd ~";
      "-- -" = "cd -";

      # Modern command replacements
      "ls" = "eza --icons --group-directories-first --time-style=long-iso";
      "ll" = "eza -l --icons --group-directories-first --git --time-style=long-iso";
      "la" = "eza -la --icons --group-directories-first --git --time-style=long-iso";
      "lt" = "eza --tree --icons --group-directories-first --level=2";
      "l" = "eza -1 --icons --group-directories-first";
      "cat" = "bat --paging=never";
      "less" = "bat";
      "find" = "fd";
      "grep" = "rg --smart-case";
      "ack" = "rg";
      "du" = "dust";
      "df" = "duf";
      "ps" = "procs --tree";
      "top" = "btop";
      "ping" = "prettyping --nolegend";
      "dig" = "dog";
      "curl" = "curlie";

      # Safety aliases
      "rm" = "rm -Iv";
      "cp" = "cp -iv";
      "mv" = "mv -iv";
      "ln" = "ln -iv";
      "chmod" = "chmod -v";
      "chown" = "chown -v";

      # System information
      "sysinfo" = "inxi -Fxxxz";
      "disk-space" = "duf";
      "ram" = "free -h";
      "ip" = "ip -color=auto";
      "ports" = "ss -tulanp";
      "temps" = "sensors";
      "battery" = "upower -i $(upower -e | grep battery)";

      # NixOS management
      "nix-update" = "sudo nixos-rebuild switch --flake \"/home/togo-gt/nixos-config#togo-gt\"";
      "nix-search" = "nix search nixpkgs";
      "nix-gc" = "sudo nix-collect-garbage --delete-older-than 7d";
      "nix-optimize" = "sudo nix-store --optimize";
      "nix-clean" = "sudo nix-collect-garbage -d && sudo nix-store --optimize";
      "nix-shell" = "nix shell";
      "nix-develop" = "nix develop";
      "rebuild" = "nix-update";
      "cleanup" = "nix-gc";

      # Development
      "g" = "git";
      "v" = "nvim";
      "vim" = "nvim";
      "py" = "python3";
      "pip" = "pip3";
      "dc" = "docker compose";
      "k" = "kubectl";

      # Gaming
      "steam-fix" = "gamemoderun steam";
      "gaming-mode" = "gamemoderun";
    };

    # ===== SHELL INIT =====
    # BEHOLDER ALT DIT EKSISTERENDE SHELLINIT - BARE FJERN ALIASES DERFRA!
    shellInit = ''
      # ===== PERFORMANCE OPTIMIZATIONS =====
      zmodload zsh/zprof
      __zsh_load_start=$((EPOCHREALTIME*1000))

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
      export PATH="$CARGO_HOME/bin:$PATH"

      # ===== GO DEVELOPMENT =====
      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"
      export PATH="$GOBIN:$PATH"

      # ===== NODE.JS DEVELOPMENT =====
      export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
      export NODE_REPL_HISTORY="$HOME/.local/share/node_repl_history"

      # ===== NIX PACKAGE MANAGER =====
      export NIXOS_CONFIG="/home/togo-gt/nixos-config/configuration.nix"
      export NIXOS_FLAKE="/home/togo-gt/nixos-config"

      # ===== SECURITY & AUTHENTICATION =====
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      # ===== APPLICATION SPECIFIC SETTINGS =====
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # ===== WAYLAND AND GRAPHICS =====
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1

      # ===== ENHANCED SHELL FUNCTIONS =====
      # BEHOLDER ALLE DINE FUNKTIONER!
      home-manager() {
          if [ "$1" = "switch" ]; then
              command home-manager "$@" 2>&1 | grep -v "unread and relevant news item"
          else
              command home-manager "$@"
          fi
      }

      mkcd() {
        if [ -z "$1" ]; then
          echo "Usage: mkcd <directory>"
          return 1
        fi
        mkdir -p "$1" && cd "$1" && pwd && eza --icons --group-directories-first
      }

      weather() {
        local location=''${1:-Copenhagen}
        curl -s --connect-timeout 5 "wttr.in/$location?0" 2>/dev/null || \
        curl -s --connect-timeout 5 "wttr.in/$location?format=3" 2>/dev/null || \
        echo "🌤️  Weather service unavailable for $location"
      }

      # ... BEHOLDER ALLE DINE ANDRE FUNKTIONER ...
      # (find-file, find-dir, extract, backup, fs, myip, pkill, nix-help, benchmark, git-overview, docker-clean)

      # ===== STARTUP MESSAGES =====
      __zsh_load_end=$((EPOCHREALTIME*1000))
      export ZSH_LOAD_TIME=$((__zsh_load_end - __zsh_load_start))

      if [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH ($(hostname -I | awk '{print $1}'))"
      fi

      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
        echo "📁 Loaded local ZSH configuration"
      fi

      if [ -z "$TMUX" ] && [ -t 1 ]; then
        echo ""
        echo "🌟 NixOS ZSH Ultra Configuration v2.0"
        echo "💡 Type 'nix-help' for useful commands"
        echo "⚡ ZSH loaded in ''${ZSH_LOAD_TIME}ms"
        echo ""
      fi
    '';
  };
}
