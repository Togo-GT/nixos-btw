# environment/shell/zsh.nix - CLEANED VERSION (NO PACKAGES)
{ pkgs, ... }:

{
  # ===== BASIC SHELL SETUP =====
  # Set ZSH as the default shell for all users
  users.defaultUserShell = pkgs.zsh;

  # Make ZSH available as a login shell in /etc/shells
  environment.shells = with pkgs; [ zsh ];

  # ===== ZSH CONFIGURATION =====
  programs.zsh = {
    # Enable ZSH - this makes ZSH work system-wide
    enable = true;

    # Smart autosuggestions (like fish shell) - suggests commands as you type
    autosuggestions.enable = true;

    # Syntax highlighting - colors commands in real-time
    syntaxHighlighting.enable = true;

    # Tab completion system
    enableCompletion = true;

    # Also enable bash completion for compatibility
    enableBashCompletion = true;

    # Better terminal integration (for tilix, termite, etc.)
    vteIntegration = true;

    # ===== OH-MY-ZSH FRAMEWORK =====
    # oh-my-zsh is a popular ZSH configuration framework
    ohMyZsh = {
      enable = true;

      # Plugins add extra functionality:
      plugins = [
        "git"           # Git aliases and functions
        "sudo"          # Press ESC twice to add sudo to current command
        "systemd"       # Systemd service management aliases
        "docker"        # Docker commands and completion
        "kubectl"       # Kubernetes commands
        "history"       # Better history management
        "colored-man-pages" # Colored manual pages
        "copyfile"      # Copy file contents to clipboard
        "copypath"      # Copy file path to clipboard
        "dirhistory"    # Directory navigation with ALT-arrows
        "web-search"    # Search web from command line
        "npm"           # Node.js package manager support
        "yarn"          # Yarn package manager support
        "rust"          # Rust toolchain support
        "python"        # Python virtualenv and pip support
        "golang"        # Go language support
        "pip"           # Python pip completion
        "virtualenv"    # Python virtual environment support
        "terraform"     # Infrastructure as code tool
        "ansible"       # Configuration management tool
      ];

      # Theme changes the look of your prompt
      theme = "agnoster";  # Popular theme with git status info
    };

    # ===== CUSTOM ZSH CONFIGURATION =====
    # shellInit contains ZSH code that runs when shell starts
    shellInit = ''
      # ===== PERFORMANCE OPTIMIZATIONS =====
      # Load performance profiling module (use zprof command to see timing)
      zmodload zsh/zprof

      # Record start time for measuring ZSH load performance
      __zsh_load_start=$((EPOCHREALTIME*1000))

      # ===== ZSH HISTORY CONFIGURATION =====
      # History settings - how many commands to remember
      HISTSIZE=100000           # Commands loaded into memory
      SAVEHIST=100000           # Commands saved to history file
      HISTFILE="$HOME/.local/state/zsh/history"  # Where to save history

      # History behavior options:
      setopt HIST_IGNORE_ALL_DUPS    # Remove duplicate commands from history
      setopt HIST_IGNORE_SPACE       # Don't save commands starting with space
      setopt HIST_REDUCE_BLANKS      # Remove extra spaces from commands
      setopt INC_APPEND_HISTORY      # Add commands to history immediately
      setopt SHARE_HISTORY           # Share history between sessions
      setopt EXTENDED_HISTORY        # Save timestamps in history
      setopt HIST_EXPIRE_DUPS_FIRST  # Remove duplicates first when history full
      setopt HIST_IGNORE_DUPS        # Don't save consecutive duplicates
      setopt HIST_SAVE_NO_DUPS       # Don't save duplicates to history file

      # Create directory for ZSH history file
      mkdir -p "$HOME/.local/state/zsh"

      # ===== DEVELOPMENT ENVIRONMENT =====
      # Python settings
      export PIP_REQUIRE_VIRTUALENV=true  # Force using virtual environments

      # Only set PYTHONSTARTUP if the file exists (prevents errors)
      if [ -f "$HOME/.config/python/pythonrc.py" ]; then
        export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"  # Python startup script
      fi

      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"  # Where Python stores cache
      export PIPX_HOME="$XDG_DATA_HOME/pipx"               # pipx installation directory
      export PIPX_BIN_DIR="$HOME/.local/bin"               # Where pipx puts binaries

      # ===== RUST DEVELOPMENT =====
      export RUSTUP_HOME="$HOME/.rustup"  # Rust toolchain manager
      export CARGO_HOME="$HOME/.cargo"    # Rust package manager
      export PATH="$CARGO_HOME/bin:$PATH"      # Add Rust binaries to PATH

      # ===== GO DEVELOPMENT =====
      export GOPATH="$HOME/go"        # Go workspace directory
      export GOBIN="$GOPATH/bin"      # Go binary output directory
      export PATH="$GOBIN:$PATH"           # Add Go binaries to PATH

      # ===== NODE.JS DEVELOPMENT =====
      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"  # npm config location
      export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history" # Node.js REPL history

      # ===== NIX PACKAGE MANAGER =====
      export NIXOS_CONFIG="/home/togo-gt/nixos-config/configuration.nix"  # Your NixOS config
      export NIXOS_FLAKE="/home/togo-gt/nixos-config"  # Your flake directory

      # ===== SECURITY & AUTHENTICATION =====
      export GPG_TTY=$(tty)                                  # GPG needs to know which terminal
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"  # SSH agent socket location

      # ===== APPLICATION SPECIFIC SETTINGS =====
      # FZF (fuzzy finder) settings:
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'  # Use fd instead of find
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"  # Same command for Ctrl+T

      # ===== WAYLAND AND GRAPHICS =====
      # Wayland is a modern display protocol (replacement for X11)
      export MOZ_ENABLE_WAYLAND=1              # Firefox uses Wayland
      export QT_QPA_PLATFORM=wayland           # Qt applications use Wayland
      export SDL_VIDEODRIVER=wayland           # Games and media use Wayland
      export _JAVA_AWT_WM_NONREPARENTING=1     # Java applications work better with Wayland

      # ===== MODERN COMMAND REPLACEMENTS =====
      # Replace old commands with modern alternatives:
      alias ls='eza --icons --group-directories-first --time-style=long-iso'  # Better ls with icons
      alias ll='eza -l --icons --group-directories-first --git --time-style=long-iso'  # Long listing with git status
      alias la='eza -la --icons --group-directories-first --git --time-style=long-iso'  # Show all files
      alias lt='eza --tree --icons --group-directories-first --level=2'  # Tree view
      alias l='eza -1 --icons --group-directories-first'  # Single column list

      alias cat='bat --paging=never'  # cat with syntax highlighting
      alias less='bat'                # Use bat instead of less
      alias find='fd'                 # Faster find command
      alias grep='rg --smart-case'    # ripgrep - faster grep with smart case
      alias ack='rg'                  # Use rg instead of ack
      alias du='dust'                 # Interactive disk usage
      alias df='duf'                  # Better disk free command
      alias ps='procs --tree'         # Better process viewer
      alias top='btop'                # Modern system monitor
      alias ping='prettyping --nolegend'  # Ping with visual graph
      alias dig='dog'                 # Modern DNS lookup
      alias curl='curlie'             # User-friendly curl

      # ===== QUALITY OF LIFE ALIASES =====
      # Navigation shortcuts:
      alias ..='cd ..'                    # Go up one directory
      alias ...='cd ../..'                # Go up two directories
      alias ....='cd ../../..'            # Go up three directories
      alias ~='cd ~'                      # Go home
      alias -- -='cd -'                   # Go to previous directory

      # Safety aliases (ask before overwriting/deleting):
      alias rm='rm -Iv'      # Confirm before removing, show what's being deleted
      alias cp='cp -iv'      # Confirm before overwriting, show files
      alias mv='mv -iv'      # Confirm before overwriting, show files
      alias ln='ln -iv'      # Confirm before creating links
      alias chmod='chmod -v' # Show what permissions are being changed
      alias chown='chown -v' # Show what ownership is being changed

      # System information aliases:
      alias sysinfo='inxi -Fxxxz'        # Detailed system information
      alias disk-space='duf'              # Show disk usage with nice formatting
      alias ram='free -h'                 # Show memory usage in human format
      alias ip='ip -color=auto'           # Show IP with colors
      alias ports='ss -tulanp'            # Show listening ports (modern netstat)
      alias temps='sensors'               # Show hardware temperatures
      alias battery='upower -i $(upower -e | grep battery)'  # Show battery info

      # ===== NIXOS MANAGEMENT ALIASES =====
      alias nix-update='sudo nixos-rebuild switch --flake "/home/togo-gt/nixos-config#togo-gt"'  # Update system
      alias nix-search='nix search nixpkgs'              # Search for packages
      alias nix-gc='sudo nix-collect-garbage --delete-older-than 7d'  # Clean old packages
      alias nix-optimize='sudo nix-store --optimize'     # Optimize Nix store
      alias nix-clean='sudo nix-collect-garbage -d && sudo nix-store --optimize'  # Full cleanup
      alias nix-shell='nix shell'                        # Enter a shell with packages
      alias nix-develop='nix develop'                    # Enter development shell
      alias rebuild='nix-update'                         # Short alias for update
      alias cleanup='nix-gc'                             # Short alias for garbage collection

      # ===== DEVELOPMENT ALIASES =====
      alias g='git'              # Short git
      alias v='nvim'             # Short neovim
      alias vim='nvim'           # Use nvim when typing vim
      alias py='python3'         # Short python
      alias pip='pip3'           # Use pip3 by default
      alias dc='docker compose'  # Short docker compose
      alias k='kubectl'          # Short kubectl

      # ===== GAMING ALIASES =====
      alias steam-fix='gamemoderun steam'  # Run Steam with performance optimizations
      alias gaming-mode='gamemoderun'      # Run any game with performance optimizations

      # ===== ENHANCED SHELL FUNCTIONS =====

      # Home Manager news filter - suppresses the unread news message
      home-manager() {
          if [ "$1" = "switch" ]; then
              # Filter out the unread news message but show everything else
              command home-manager "$@" 2>&1 | grep -v "unread and relevant news item"
          else
              command home-manager "$@"
          fi
      }

      # mkcd: Create directory and immediately cd into it
      mkcd() {
        if [ -z "$1" ]; then
          echo "Usage: mkcd <directory>"
          return 1
        fi
        mkdir -p "$1" && cd "$1" && pwd && eza --icons --group-directories-first
      }

      # weather: Show weather forecast for any city
      weather() {
        local location=''${1:-Copenhagen}  # Default to Copenhagen if no city given
        curl -s --connect-timeout 5 "wttr.in/$location?0" 2>/dev/null || \
        curl -s --connect-timeout 5 "wttr.in/$location?format=3" 2>/dev/null || \
        echo "🌤️  Weather service unavailable for $location"
      }

      # find-file: Find files and show preview of first result
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

      # find-dir: Find directories by name
      find-dir() {
        if [ -z "$1" ]; then
          echo "Usage: find-dir <pattern>"
          return 1
        fi
        fd -t d -s "$1" 2>/dev/null
      }

      # extract: Extract any archive format automatically
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

        # Handle different file formats
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

        # Check if extraction was successful
        if [ $? -eq 0 ]; then
          echo "✅ Successfully extracted: $1"
        else
          echo "❌ Failed to extract: $1"
        fi
      }

      # backup: Create timestamped backup of a file
      backup() {
        if [ -z "$1" ]; then
          echo "Usage: backup <file>"
          return 1
        fi
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="$1.backup_$timestamp"
        cp -v "$1" "$backup_file" && echo "✅ Backup created: $backup_file"
      }

      # fs: Show file/directory size with error handling
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

      # myip: Show both public and local IP addresses
      myip() {
        echo "🌐 Network Information:"
        echo "   Public IP: $(curl -s --connect-timeout 3 ifconfig.me 2>/dev/null || echo 'Unknown')"
        echo "   Local IP: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'Unknown')"
      }

      # pkill: Safely kill processes by name with confirmation
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

      # nix-help: Show helpful NixOS commands
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

      # ===== STARTUP MESSAGES =====

      # Calculate how long ZSH took to load
      __zsh_load_end=$((EPOCHREALTIME*1000))
      export ZSH_LOAD_TIME=$((__zsh_load_end - __zsh_load_start))

      # Show message when connecting via SSH
      if [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH ($(hostname -I | awk '{print $1}'))"
      fi

      # Load user-specific local configuration if it exists
      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
        echo "📁 Loaded local ZSH configuration"
      fi

      # Welcome message (only show in interactive terminals, not in scripts)
      if [ -z "$TMUX" ] && [ -t 1 ]; then
        echo ""
        echo "🌟 NixOS ZSH Ultra Configuration v2.0"
        echo "💡 Type 'nix-help' for useful commands"
        echo "⚡ ZSH loaded in ''${ZSH_LOAD_TIME}ms"
        echo ""
      fi
    '';

    # ===== SHELL ALIASES =====
    # These are simple command shortcuts defined in Nix (not in shellInit)
    shellAliases = {
      # Basic navigation aliases (these work everywhere)
      ".." = "cd ..";           # Go up one directory
      "..." = "cd ../..";       # Go up two directories
      "...." = "cd ../../..";   # Go up three directories
      "ll" = "eza -l --icons --git";    # List files with details
      "la" = "eza -la --icons --git";   # List all files (including hidden)
    };
  };
}
