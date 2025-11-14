# zsh-fix.nix - Komplet ZSH konfiguration
{ config, pkgs, lib, ... }:

{
  # Set ZSH as default shell
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git" "sudo" "systemd" "docker" "kubectl"
        "history" "colored-man-pages" "copyfile"
        "copypath" "dirhistory" "web-search"
        "npm" "yarn" "rust" "python" "golang"
      ];
      theme = "agnoster";
    };

    shellInit = ''
      # Environment Variables
      export LANG="en_DK.UTF-8"
      export LC_ALL="en_DK.UTF-8"
      export TZ="Europe/Copenhagen"

      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="bat"
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"

      export PIP_REQUIRE_VIRTUALENV=true
      export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"
      export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"

      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"
      export PATH="$CARGO_HOME/bin:$PATH"

      export GOPATH="$HOME/go"
      export GOBIN="$GOPATH/bin"
      export PATH="$GOBIN:$PATH"

      export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
      export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

      export HISTSIZE=100000
      export SAVEHIST=100000
      export HISTFILE="$XDG_STATE_HOME/zsh/history"

      export BAT_THEME="TwoDark"
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export NIX_CONFIG="experimental-features = nix-command flakes"

      # History Configuration
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt INC_APPEND_HISTORY
      setopt SHARE_HISTORY

      # Modern Command Replacements
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -l --icons --group-directories-first --git'
      alias la='eza -la --icons --group-directories-first --git'
      alias lt='eza --tree --icons --group-directories-first'
      alias cat='bat'
      alias less='bat'
      alias find='fd'
      alias grep='rg'
      alias ack='rg'
      alias du='dust'
      alias df='duf'
      alias ps='procs'
      alias top='btop'
      alias ping='prettyping --nolegend'

      # Quality of Life Aliases
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'
      alias rm='rm -i'
      alias cp='cp -i'
      alias mv='mv -i'
      alias ln='ln -i'
      alias sysinfo='inxi -Fxz'
      alias disk-space='df -h | grep -v tmpfs'
      alias ram='free -h'
      alias ip='ip -color=auto'
      alias ports='netstat -tulanp'
      alias update-all='sudo nixos-rebuild switch --upgrade && flatpak update -y'
      alias nix-search='nix search nixpkgs'
      alias nix-gc='sudo nix-collect-garbage --delete-older-than 7d'
      alias nix-optimize='sudo nix-store --optimize'
      alias nix-clean='sudo nix-collect-garbage -d && sudo nix-store --optimize'
      alias docker-clean='docker system prune -af'
      alias docker-compose='docker compose'
      alias dps='docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"'
      alias g='git'
      alias v='nvim'
      alias vim='nvim'
      alias py='python3'
      alias pip='pip3'
      alias steam-fix='gamemoderun steam'
      alias gaming-mode='gamemoderun'

      # Custom Functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
      weather() { curl "wttr.in/''${1:-Copenhagen}?0"; }
      find-file() { find . -type f -name "*$1*" 2>/dev/null; }
      find-dir() { find . -type d -name "*$1*" 2>/dev/null; }

      extract() {
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

      backup() { cp "$1" "$1.bak"; }
      fs() { du -sh "$1" 2>/dev/null || echo "File not found"; }
      myip() { curl -s ifconfig.me; echo; }

      nix-update() {
        sudo nixos-rebuild switch --flake "/home/togo-gt/nixos-config#togo-gt"
      }

      nix-help() {
        echo "🚀 NixOS ZSH Help:"
        echo "  nix-update        - Update system configuration"
        echo "  nix-clean         - Clean old generations and optimize"
        echo "  nix-search        - Search for packages"
        echo "  update-all        - Update system and flatpaks"
        echo "  mkcd <dir>        - Create and enter directory"
        echo "  weather [city]    - Show weather forecast"
        echo "  extract <file>    - Extract any archive"
        echo "  sysinfo           - Show system information"
      }

      # Startup Messages
      if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
        echo "🔧 Connected to $(hostname) via SSH"
      fi

      if [ -f "$HOME/.config/zsh/local.zsh" ]; then
        source "$HOME/.config/zsh/local.zsh"
      fi

      echo "🌟 NixOS ZSH configuration loaded successfully!"
      echo "💡 Type 'nix-help' for useful commands"
    '';

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
      "rebuild" = "sudo nixos-rebuild switch --flake /home/togo-gt/nixos-config#togo-gt";
      "cleanup" = "sudo nix-collect-garbage -d";

      # System info
      "ip" = "ip --color=auto";
      "grep" = "grep --color=auto";
    };
  };
}
