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
    shellInit = ''
      # ===== PERFORMANCE OPTIMIZATIONS =====
      zmodload zsh/zprof
      __zsh_load_start=$((EPOCHREALTIME*1000))

      # ===== ZSH HISTORY CONFIGURATION =====
      # HISTORY SETTINGS - DISSE SKAL VÆRE I shellInit I NIXOS!
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

      backup() {
        if [ -z "$1" ]; then
          echo "Usage: backup <file>"
          return 1
        fi
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="$1.backup_$timestamp"
        cp -v "$1" "$backup_file" && echo "✅ Backup created: $backup_file"
      }

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

      myip() {
        echo "🌐 Network Information:"
        echo "   Public IP: $(curl -s --connect-timeout 3 ifconfig.me 2>/dev/null || echo 'Unknown')"
        echo "   Local IP: $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'Unknown')"
      }

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

      docker-clean() {
        echo "🧹 Cleaning Docker system..."
        docker system prune -af
        docker volume prune -f
        docker network prune -f
        echo "✅ Docker cleanup complete!"
      }

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
