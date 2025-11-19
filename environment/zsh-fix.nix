# environment/zsh-fix.nix - ULTRA OPTIMIZED VERSION
{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    enableBashCompletion = true;  # Tilføj bash completion support
    enableVteIntegration = true;  # Bedre terminal integration

    ohMyZsh = {
      enable = true;
      plugins = [
        "git" "sudo" "systemd" "docker" "kubectl"
        "history" "colored-man-pages" "copyfile"
        "copypath" "dirhistory" "web-search"
        "npm" "yarn" "rust" "python" "golang"
        "pip" "virtualenv" "terraform" "ansible"  # Tilføjede plugins
      ];
      theme = "agnoster";
      custom = "$HOME/.config/zsh/custom";  # Custom plugins sti
    };

    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.local/state/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    dotDir = ".config/zsh";  # Flyt ZSH config til XDG standard

    shellInit = ''
      # ===== PERFORMANCE OPTIMIZATIONS =====
      zmodload zsh/zprof  # Performance profiling
      __zsh_load_start=$((EPOCHREALTIME*1000))  # Load timing

      # ===== ENVIRONMENT VARIABLES =====
      export LANG="en_DK.UTF-8"
      export LC_ALL="en_DK.UTF-8"
      export TZ="Europe/Copenhagen"

      # XDG Base Directory Compliance
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      # Create necessary directories
      mkdir -p "$XDG_CONFIG_HOME/zsh" "$XDG_DATA_HOME/zsh" "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

      # Editor & Pager Configuration
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="bat"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      # Development Environment
      export PIP_REQUIRE_VIRTUALENV=true
      # Smart Python startup file check
      if [ -f "$HOME/.config/python/pythonrc.py" ]; then
        export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"
      fi
      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
      export PIPX_HOME="$XDG_DATA_HOME/pipx"
      export PIPX_BIN_DIR="$HOME/.local/bin"

      # Rust Environment
      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"
      path=("$CARGO_HOME/bin" $path)  # ZSH native path manipulation

      # Go Environment
      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"
      path=("$GOBIN" $path)

      # Node.js Environment
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

      # Nix Configuration
      export NIX_CONFIG="experimental-features = nix-command flakes"
      export NIXOS_CONFIG="/home/togo-gt/nixos-config/configuration.nix"
      export NIXOS_FLAKE="/home/togo-gt/nixos-config"

      # Security & Authentication
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      # Application Specific
      export BAT_THEME="TwoDark"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # Wayland and Graphics
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1

      # ===== HISTORY CONFIGURATION =====
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_REDUCE_BLANKS
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY
      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_SAVE_NO_DUPS

      # ===== MODERN COMMAND REPLACEMENTS =====
      alias ls='eza --icons --group-directories-first --time-style=long-iso'
      alias ll='eza -l --icons --group-directories-first --git --time-style=long-iso'
      alias la='eza -la --icons --group-directories-first --git --time-style=long-iso'
      alias lt='eza --tree --icons --group-directories-first --level=2'
      alias l='eza -1 --icons --group-directories-first'

      alias cat='bat --paging=never'
      alias less='bat'
      alias find='fd'
      alias grep='rg --smart-case'
      alias ack='rg'
      alias du='dust'
      alias df='duf'
      alias ps='procs --tree'
      alias top='btop'
      alias ping='prettyping --nolegend'
      alias dig='dog'
      alias curl='curlie'

      # ===== QUALITY OF LIFE ALIASES =====
      # Navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias ~='cd ~'
      alias -- -='cd -'

      # Safety with verbose feedback
      alias rm='rm -Iv'
      alias cp='cp -iv'
      alias mv='mv -iv'
      alias ln='ln -iv'
      alias chmod='chmod -v'
      alias chown='chown -v'

      # System Information
      alias sysinfo='inxi -Fxxxz'
      alias disk-space='duf'
      alias ram='free -h'
      alias ip='ip -color=auto'
      alias ports='ss -tulanp'
      alias temps='sensors'
      alias battery='upower -i $(upower -e | grep battery)'

      # NixOS Management
      alias nix-update='sudo nixos-rebuild switch --flake "/home/togo-gt/nixos-config#togo-gt"'
      alias nix-search='nix search nixpkgs'
      alias nix-gc='sudo nix-collect-garbage --delete-older-than 7d'
      alias nix-optimize='sudo nix-store --optimize'
      alias nix-clean='sudo nix-collect-garbage -d && sudo nix-store --optimize'
      alias nix-shell='nix shell'
      alias nix-develop='nix develop'
      alias rebuild='nix-update'
      alias cleanup='nix-gc'

      # Development
      alias g='git'
      alias v='nvim'
      alias vim='nvim'
      alias py='python3'
      alias pip='pip3'
      alias dc='docker compose'
      alias k='kubectl'

      # Gaming
      alias steam-fix='gamemoderun steam'
      alias gaming-mode='gamemoderun'

      # ===== ENHANCED FUNCTIONS =====

      # Smart directory creation and navigation
      mkcd() {
        if [ -z "$1" ]; then
          echo "Usage: mkcd <directory>"
          return 1
        fi
        mkdir -p "$1" && cd "$1" && pwd && eza --icons --group-directories-first
      }

      # Enhanced weather with multiple fallbacks
      weather() {
        local location=''${1:-Copenhagen}
        curl -s --connect-timeout 5 "wttr.in/$location?0" 2>/dev/null || \
        curl -s --connect-timeout 5 "wttr.in/$location?format=3" 2>/dev/null || \
        echo "🌤️  Weather service unavailable for $location"
      }

      # Smart file finding with preview
      find-file() {
        if [ -z "$1" ]; then
          echo "Usage: find-file <pattern>"
          return 1
        fi
        local result=$(fd -t f -s "$1" 2>/dev/null | head -20)
        if [ -n "$result" ]; then
          echo "🔍 Found files:"
          echo "$result"
          echo ""
          echo "📄 Preview of first result:"
          bat --color=always --style=numbers "$(echo "$result" | head -1)" 2>/dev/null | head -20
        else
          echo "❌ No files found matching: $1"
        fi
      }

      find-dir() {
        if [ -z "$1" ]; then
          echo "Usage: find-dir <pattern>"
          return 1
        fi
        fd -t d -s "$1" 2>/dev/null
      }

      # Enhanced extraction with more formats and error handling
      extract() {
        if [ -z "$1" ]; then
          echo "Usage: extract <file>"
          echo "Supported formats: .tar.gz .tar.bz2 .tar.xz .tar .zip .rar .7z .gz .bz2 .xz .zst .deb .rpm"
          return 1
        fi

        if [ ! -f "$1" ]; then
          echo "❌ Error: '$1' is not a valid file"
          return 1
        fi

        case "$1" in
          *.tar.bz2|*.tbz2) tar xjf "$1" ;;
          *.tar.gz|*.tgz)   tar xzf "$1" ;;
          *.tar.xz|*.txz)   tar xJf "$1" ;;
          *.tar.zst|*.tzst) tar --zstd -xf "$1" ;;
          *.tar)            tar xf "$1" ;;
          *.zip)            unzip "$1" ;;
          *.rar)            unrar x "$1" ;;
          *.7z)             7z x "$1" ;;
          *.gz)             gunzip "$1" ;;
          *.bz2)            bunzip2 "$1" ;;
          *.xz)             unxz "$1" ;;
          *.zst)            unzstd "$1" ;;
          *.deb)            ar x "$1" ;;
          *.rpm)            rpm2cpio "$1" | cpio -idmv ;;
          *)                echo "❌ '$1' cannot be extracted via extract()" ; return 1 ;;
        esac

        if [ $? -eq 0 ]; then
          echo "✅ Successfully extracted: $1"
        else
          echo "❌ Failed to extract: $1"
        fi
      }

      # Backup with timestamp and rotation
      backup() {
        if [ -z "$1" ]; then
          echo "Usage: backup <file>"
          return 1
        fi
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="$1.backup_$timestamp"
        cp -v "$1" "$backup_file" && echo "✅ Backup created: $backup_file"
      }

      # File size with human readable output and error handling
      fs() {
        if [ -z "$1" ]; then
          echo "Usage: fs <file_or_directory>"
          return 1
        fi
        if [ -e "$1" ]; then
          du -sh "$1" 2>/dev/null || echo "❌ Error getting size for: $1"
        else
          echo "❌ File not found: $1"
        fi
      }

      # Enhanced network information
      myip() {
        echo "🌐 Network Information:"
        echo "   Public IP: $(curl -s --connect-timeout 3 ifconfig.me 2>/dev/null || echo 'Unknown')"
        echo "   Local IP: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'Unknown')"
      }

      # Process management with safety
      pkill() {
        if [ -z "$1" ]; then
          echo "Usage: pkill <process_name>"
          return 1
        fi
        local pids=$(pgrep -f "$1")
        if [ -n "$pids" ]; then
          echo "🛑 Killing processes: $pids"
          echo "Process details:"
          ps -p $pids -o pid,user,command
          echo ""
          read "?Are you sure? [y/N] " response
          case "$response" in
            [yY][eE][sS]|[yY])
              kill -9 $pids
              echo "✅ Processes killed"
              ;;
            *)
              echo "❌ Operation cancelled"
              ;;
          esac
        else
          echo "❌ No processes found matching: $1"
        fi
      }

      # NixOS helpers with better formatting
      nix-help() {
        echo "🚀 NixOS ZSH Help"
        echo "=================="
        echo "🛠️  System Management:"
        echo "  nix-update        - Update system configuration"
        echo "  nix-clean         - Clean old generations and optimize"
        echo "  nix-search        - Search for packages"
        echo "  rebuild           - Alias for nix-update"
        echo ""
        echo "📦 Package Management:"
        echo "  update-all        - Update system and flatpaks"
        echo "  nix-shell         - Enter nix shell"
        echo "  nix-develop       - Enter development shell"
        echo ""
        echo "📁 File Operations:"
        echo "  mkcd <dir>        - Create and enter directory"
        echo "  extract <file>    - Extract any archive"
        echo "  backup <file>     - Create timestamped backup"
        echo "  fs <file/dir>     - Show file/directory size"
        echo ""
        echo "🌐 Network & Info:"
        echo "  weather [city]    - Show weather forecast"
        echo "  myip              - Show network information"
        echo "  sysinfo           - Show system information"
        echo ""
        echo "⚡ Process Management:"
        echo "  pkill <process>   - Kill processes by name (with confirmation)"
      }

      # Performance benchmarking
      benchmark() {
        echo "⏱️  System Benchmark"
        echo "===================="
        echo "💻 CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
        echo "💾 Memory: $(free -h | grep Mem | awk '{print $2}')"
        echo "💿 Disk: $(lsblk -o SIZE,MODEL | head -2 | tail -1)"
        echo ""

        echo "ZSH load time: $((($((EPOCHREALTIME*1000)) - __zsh_load_start))ms"

        echo "Command execution times:"
        echo -n "  ls:          "; time (ls >/dev/null 2>&1)
        echo -n "  git status:  "; time (git status >/dev/null 2>&1)
        echo -n "  nvim --version: "; time (nvim --version >/dev/null 2>&1)
      }

      # Git overview
      git-overview() {
        echo "📊 Git Repository Overview"
        echo "=========================="
        git branch -av
        echo ""
        git status -s
        echo ""
        echo "📝 Recent commits:"
        git log --oneline -5
      }

      # Docker cleanup
      docker-clean() {
        echo "🧹 Cleaning Docker system..."
        docker system prune -af
        docker volume prune -f
        docker network prune -f
        echo "✅ Docker cleanup complete!"
      }

      # ===== STARTUP OPTIMIZATIONS =====

      # Load performance metrics
      __zsh_load_end=$((EPOCHREALTIME*1000))
      export ZSH_LOAD_TIME=$((__zsh_load_end - __zsh_load_start))

      # Conditional startup messages
      if [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH ($(hostname -I | awk '{print $1}'))"
      fi

      # Load local configuration if available
      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
        echo "📁 Loaded local ZSH configuration"
      fi

      # Welcome message with system info
      if [ -z "$TMUX" ] && [ -t 1 ]; then
        echo ""
        echo "🌟 NixOS ZSH Ultra Configuration v2.0"
        echo "💡 Type 'nix-help' for useful commands"
        echo "⚡ ZSH loaded in ''${ZSH_LOAD_TIME}ms"
        echo ""
      fi
    '';

    shellAliases = {
      # Minimal essential aliases only
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "ll" = "eza -l --icons --git";
      "la" = "eza -la --icons --git";
    };

    sessionVariables = {
      # Critical session variables for reliability
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
      ZSH_AUTOSUGGEST_STRATEGY = "match_prev_cmd";
      DISABLE_MAGIC_FUNCTIONS = "true"; # Fix paste issues
    };
  };
}
