# zsh-fix.nix - Complete ZSH configuration
{ config, pkgs, ... }:

{
  # =============================================
  # ZSH SHELL CONFIGURATION
  # =============================================
  programs.zsh = {
    enable = true;

    # ===========================================
    # OH-MY-ZSH PLUGINS AND THEME
    # ===========================================
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"           # Git aliases and functions
        "sudo"          # Double ESC to prefix with sudo
        "systemd"       # Systemd service management shortcuts
        "docker"        # Docker command completion
        "kubectl"       # Kubernetes command completion
        "history"       # Better history management
        "colored-man-pages" # Colorized manual pages
        "copyfile"      # Copy file contents to clipboard
        "copypath"      # Copy file path to clipboard
        "dirhistory"    # Directory navigation with alt+arrows
        "web-search"    # Web search from terminal
        "npm"           # Node.js package manager completion
        "yarn"          # Yarn package manager completion
        "rust"          # Rust development tools
        "python"        # Python development tools
        "golang"        # Go development tools
      ];
      theme = "agnoster";  # Powerline-style prompt theme
    };

    # ===========================================
    # ZSH ENHANCEMENTS
    # ===========================================
    autosuggestions.enable = true;     # Fish-like auto-suggestions
    syntaxHighlighting.enable = true;  # Command syntax highlighting
    enableCompletion = true;           # Advanced tab completion

    # ===========================================
    # SHELL INITIALIZATION SCRIPT
    # ===========================================
    shellInit = ''
      # =========================================
      # ENVIRONMENT VARIABLES
      # =========================================

      # Language and regional settings
      export LANG="en_DK.UTF-8"
      export LC_ALL="en_DK.UTF-8"
      export TZ="Europe/Copenhagen"

      # XDG Base Directory specification
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      # Editor and pager configuration
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="bat"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      # Python development environment
      export PIP_REQUIRE_VIRTUALENV=true
      export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"
      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"

      # Rust development environment
      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"
      export PATH="$CARGO_HOME/bin:$PATH"

      # Go development environment
      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"
      export PATH="$GOBIN:$PATH"

      # Node.js development environment
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

      # Security and authentication
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      # History configuration
      export HISTSIZE=100000
      export SAVEHIST=100000
      export HISTFILE="$XDG_STATE_HOME/zsh/history"
      setopt HIST_IGNORE_ALL_DUPS   # Ignore duplicate commands
      setopt HIST_SAVE_NO_DUPS      # Save without duplicates
      setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks
      setopt INC_APPEND_HISTORY     # Append to history immediately
      setopt SHARE_HISTORY          # Share history between sessions

      # Application theming and behavior
      export BAT_THEME="TwoDark"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

      # Nix configuration
      export NIX_CONFIG="experimental-features = nix-command flakes"

      # =========================================
      # MODERN COMMAND REPLACEMENTS
      # =========================================

      # Enhanced file listing with eza
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -l --icons --group-directories-first --git'
      alias la='eza -la --icons --group-directories-first --git'
      alias lt='eza --tree --icons --group-directories-first'
      alias l='eza -l --icons --group-directories-first'

      # Enhanced file viewing with bat
      alias cat='bat'
      alias less='bat'

      # Modern search tools
      alias find='fd'
      alias grep='rg'
      alias ack='rg'

      # Enhanced system monitoring
      alias du='dust'
      alias df='duf'
      alias ps='procs'
      alias top='btop'

      # Enhanced network tools
      alias ping='prettyping --nolegend'

      # =========================================
      # QUALITY OF LIFE ALIASES
      # =========================================

      # Directory navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'

      # Safety nets for file operations
      alias rm='rm -i'
      alias cp='cp -i'
      alias mv='mv -i'
      alias ln='ln -i'

      # System information shortcuts
      alias sysinfo='inxi -Fxz'
      alias disk-space='df -h | grep -v tmpfs'
      alias ram='free -h'
      alias ip='ip -color=auto'
      alias ports='netstat -tulanp'

      # Package management shortcuts
      alias update-all='sudo nixos-rebuild switch --upgrade && flatpak update -y'
      alias nix-search='nix search nixpkgs'
      alias nix-gc='sudo nix-collect-garbage --delete-older-than 7d'
      alias nix-optimize='sudo nix-store --optimize'
      alias nix-clean='sudo nix-collect-garbage -d && sudo nix-store --optimize'

      # Docker and container management
      alias docker-clean='docker system prune -af'
      alias docker-compose='docker compose'
      alias dps='docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"'

      # Development shortcuts
      alias g='git'
      alias v='nvim'
      alias vim='nvim'
      alias py='python3'
      alias pip='pip3'

      # Gaming enhancements
      alias steam-fix='gamemoderun steam'
      alias gaming-mode='gamemoderun'

      # =========================================
      # CUSTOM SHELL FUNCTIONS
      # =========================================

      # Create directory and enter it
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Weather information
      function weather() {
        curl "wttr.in/''${1:-Copenhagen}?0"
      }

      # File search functions
      function find-file() {
        find . -type f -name "*$1*" 2>/dev/null
      }
      function find-dir() {
        find . -type d -name "*$1*" 2>/dev/null
      }

      # Archive extraction function
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

      # File backup function
      function backup() {
        cp "$1" "$1.bak"
      }

      # File size calculation
      function fs() {
        du -sh "$1" 2>/dev/null || echo "File not found"
      }

      # Public IP address lookup
      function myip() {
        curl -s ifconfig.me
        echo
      }

      # NixOS helper functions
      function nix-update() {
        sudo nixos-rebuild switch --flake ".#''${1:-nixos-btw}"
      }

      # Help function for NixOS commands
      function nix-help() {
        echo "NixOS ZSH Help Commands:"
        echo "  nix-update [host] - Update system configuration"
        echo "  nix-clean         - Clean old generations and optimize store"
        echo "  nix-search        - Search for packages in nixpkgs"
        echo "  update-all        - Update system and flatpaks"
        echo "  mkcd <dir>        - Create and enter directory"
        echo "  weather [city]    - Show weather forecast for city"
        echo "  extract <file>    - Extract any archive format"
        echo "  sysinfo           - Show detailed system information"
      }

      # =========================================
      # STARTUP MESSAGES AND UTILITIES
      # =========================================

      # Welcome message for SSH connections
      if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
        echo "Connected to $(hostname) via SSH"
      fi

      # First login message
      if [ -n "$FIRST_LOGIN" ]; then
        echo "NixOS ZSH configuration loaded successfully!"
        echo "Type 'nix-help' for useful NixOS commands"
        unset FIRST_LOGIN
      fi

      # Load user-specific local configuration
      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
      fi
    '';

    # ===========================================
    # SHELL ALIASES
    # ===========================================
    shellAliases = {
      # Quick navigation aliases
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Safety aliases
      "rm" = "rm -i";
      "cp" = "cp -i";
      "mv" = "mv -i";

      # NixOS management aliases
      "rebuild" = "sudo nixos-rebuild switch --flake .#";
      "cleanup" = "sudo nix-collect-garbage -d";

      # System information aliases
      "ip" = "ip --color=auto";
      "grep" = "grep --color=auto";
    };
  };

  # =============================================
  # SET ZSH AS DEFAULT SHELL
  # =============================================
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
}
