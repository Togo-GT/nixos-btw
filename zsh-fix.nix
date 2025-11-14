# zsh-fix.nix - Komplet ZSH konfiguration der erstatter .zshrc/.bashrc
# Brug: Tilføj denne fil til din flake.nix imports
{ config, pkgs, ... }:

{
  # ===========================================================================
  # KOMPLET ZSH KONFIGURATION - ERSTATTER ~/.zshrc OG ~/.bashrc
  # ===========================================================================

  programs.zsh = {
    enable = true;

    # =========================================================================
    # OH-MY-ZSH CONFIGURATION
    # =========================================================================
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"           # 🔧 Git aliases: gst, gco, gcmsg, etc.
        "sudo"          # ⚡ Double ESC to prefix with sudo
        "systemd"       # 🖥️ systemctl, journalctl shortcuts
        "docker"        # 🐳 Docker commands
        "kubectl"       # ☸️ Kubernetes commands
        "history"       # 📜 Better history management
        "colored-man-pages" # 🎨 Colorized manual pages
        "copyfile"      # 📋 Copy file contents to clipboard
        "copypath"      # 📁 Copy file path to clipboard
        "dirhistory"    # 📂 Directory navigation: alt+left/right
        "web-search"    # 🌐 Search web from terminal: google, ddg
        "npm"           # 📦 Node.js package manager
        "yarn"          # 🧶 Faster npm alternative
        "rust"          # 🦀 Rust development
        "python"        # 🐍 Python development
        "golang"        # 🐹 Go development
      ];
      theme = "agnoster"; # 🎨 Powerline-style prompt
    };

    # =========================================================================
    # ZSH ENHANCEMENTS
    # =========================================================================
    autosuggestions.enable = true;     # 🤖 Fish-like auto-suggestions
    syntaxHighlighting.enable = true;  # 🎨 Command syntax coloring
    enableCompletion = true;           # 🔄 Advanced tab completion

    # =========================================================================
    # SHELL INIT - ERSTATTER ALT FRA .zshrc/.bashrc
    # =========================================================================
    # 🚨 FIXED: Use shellInit for NixOS system configuration
    shellInit = ''
      # =======================================================================
      # ENVIRONMENT VARIABLES - SYSTEM WIDE SETTINGS
      # =======================================================================

      # 🕐 Language & Region
      export LANG="en_DK.UTF-8"
      export LC_ALL="en_DK.UTF-8"
      export TZ="Europe/Copenhagen"

      # 📁 XDG Base Directory Standard
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      # 🔧 Development & Editors
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="bat"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      # 🐍 Python Development
      export PIP_REQUIRE_VIRTUALENV=true
      export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"
      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"

      # 🦀 Rust Development
      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"
      export PATH="$CARGO_HOME/bin:$PATH"

      # 🐹 Go Development
      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"
      export PATH="$GOBIN:$PATH"

      # 🟨 Node.js Development
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

      # 🔐 Security & Keys
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      # 📊 History Configuration
      export HISTSIZE=100000
      export SAVEHIST=100000
      export HISTFILE="$XDG_STATE_HOME/zsh/history"
      setopt HIST_IGNORE_ALL_DUPS   # Remove duplicate commands
      setopt HIST_SAVE_NO_DUPS      # Save without duplicates
      setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks
      setopt INC_APPEND_HISTORY     # Append immediately
      setopt SHARE_HISTORY          # Share between sessions

      # 🎨 Application Themes
      export BAT_THEME="TwoDark"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

      # 🚀 Nix Configuration
      export NIX_CONFIG="experimental-features = nix-command flakes"

      # =======================================================================
      # MODERN COMMAND REPLACEMENTS - BETTER DEFAULT TOOLS
      # =======================================================================

      # 📁 File Listing
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -l --icons --group-directories-first --git'
      alias la='eza -la --icons --group-directories-first --git'
      alias lt='eza --tree --icons --group-directories-first'
      alias l='eza -l --icons --group-directories-first'

      # 📄 File Content
      alias cat='bat'
      alias less='bat'

      # 🔍 Search & Find
      alias find='fd'
      alias grep='rg'
      alias ack='rg'

      # 📊 System Monitoring
      alias du='dust'
      alias df='duf'
      alias ps='procs'
      alias top='btop'

      # 🌐 Network
      alias ping='prettyping --nolegend'

      # =======================================================================
      # QUALITY OF LIFE ALIASES
      # =======================================================================

      # 🗂️ Navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'

      # 🛡️ Safety Nets
      alias rm='rm -i'
      alias cp='cp -i'
      alias mv='mv -i'
      alias ln='ln -i'

      # 🔧 System Information
      alias sysinfo='inxi -Fxz'
      alias disk-space='df -h | grep -v tmpfs'
      alias ram='free -h'
      alias ip='ip -color=auto'
      alias ports='netstat -tulanp'

      # 📦 Package Management
      alias update-all='sudo nixos-rebuild switch --upgrade && flatpak update -y'
      alias nix-search='nix search nixpkgs'
      alias nix-gc='sudo nix-collect-garbage --delete-older-than 7d'
      alias nix-optimize='sudo nix-store --optimize'
      alias nix-clean='sudo nix-collect-garbage -d && sudo nix-store --optimize'

      # 🐳 Docker & Containers
      alias docker-clean='docker system prune -af'
      alias docker-compose='docker compose'
      alias dps='docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"'

      # 🔧 Development
      alias g='git'
      alias v='nvim'
      alias vim='nvim'
      alias py='python3'
      alias pip='pip3'

      # 🎮 Gaming
      alias steam-fix='gamemoderun steam'
      alias gaming-mode='gamemoderun'

      # =======================================================================
      # CUSTOM FUNCTIONS
      # =======================================================================

      # 📁 Create and enter directory
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # 🌤️ Weather information
      function weather() {
        curl "wttr.in/''${1:-Copenhagen}?0"
      }

      # 🔍 Find files and directories
      function find-file() {
        find . -type f -name "*$1*" 2>/dev/null
      }
      function find-dir() {
        find . -type d -name "*$1*" 2>/dev/null
      }

      # 📦 Extract any archive
      function extract() {
        if [ -f "$1" ] ; then
          case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.deb) ar x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # 🔄 Create backup of file
      function backup() {
        cp "$1" "$1.bak"
      }

      # 📊 Calculate file size
      function fs() {
        du -sh "$1" 2>/dev/null || echo "File not found"
      }

      # 🌐 Get public IP
      function myip() {
        curl -s ifconfig.me
        echo
      }

      # 🔧 NixOS helpers
      function nix-update() {
        sudo nixos-rebuild switch --flake ".#''${1:-nixos-btw}"
      }

      function nix-help() {
        echo "🚀 NixOS ZSH Help:"
        echo "  nix-update [host] - Update system configuration"
        echo "  nix-clean         - Clean old generations and optimize"
        echo "  nix-search        - Search for packages"
        echo "  update-all        - Update system and flatpaks"
        echo "  mkcd <dir>        - Create and enter directory"
        echo "  weather [city]    - Show weather forecast"
        echo "  extract <file>    - Extract any archive"
        echo "  sysinfo           - Show system information"
      }

      # =======================================================================
      # STARTUP MESSAGES & UTILITIES
      # =======================================================================

      # 🎯 Welcome message
      if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH"
      fi

      # 📊 Show system info on first login
      if [ -n "$FIRST_LOGIN" ]; then
        echo "🌟 NixOS ZSH configuration loaded successfully!"
        echo "💡 Type 'nix-help' for useful commands"
        unset FIRST_LOGIN
      fi

      # 🎨 Load user-specific overrides (for things that can't be in NixOS)
      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
      fi
    '';

    # =========================================================================
    # SHELL ALIASES - GLOBAL ALIASES
    # =========================================================================
    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Safety
      "rm" = "rm -i";
      "cp" = "cp -i";
      "mv" = "mv -i";

      # NixOS
      "rebuild" = "sudo nixos-rebuild switch --flake .#";
      "cleanup" = "sudo nix-collect-garbage -d";

      # System info
      "ip" = "ip --color=auto";
      "grep" = "grep --color=auto";
    };
  };

  # ===========================================================================
  # SET ZSH AS DEFAULT SHELL
  # ===========================================================================
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
}
