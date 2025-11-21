# /home/togo-gt/nixos-config/home.nix - Home Manager Configuration
{ ... }:

{
  # Basic user information
  home.username = "togo-gt";
  home.homeDirectory = "/home/togo-gt";
  home.stateVersion = "25.05";

  # Turn off Home Manager news messages
  news.display = "silent";

  # List of packages to install (only user-specific packages)
  home.packages = [
    # Only include packages that are NOT in your system configuration
  ];

  # Program configurations
  programs = {
    # Git version control setup
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "nvim";
        merge.conflictstyle = "diff3";
        user.name = "Togo-GT";
        user.email = "michael.kaare.nielsen@gmail.com";
      };
      ignores = [
        ".DS_Store" "*.swp" "*.swo" ".direnv/" "node_modules/"
        "__pycache__/" "*.pyc" ".mypy_cache/" ".pytest_cache/"
      ];
    };

    # Neovim text editor setup
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Remove ALL ZSH configuration from here - it's in zsh.nix now
  };

  # Background services
  services = {
    syncthing.enable = false;
  };

  # Custom files to create
  home.file = {
    # ZSH functions file with useful commands
    ".config/zsh/user-functions.zsh" = {
      text = ''
        # User-specific ZSH functions

        # Edit NixOS configuration
        nix-edit() {
          nvim /home/togo-gt/nixos-config/configuration.nix
        }

        # Edit Home Manager configuration
        hm-edit() {
          nvim /home/togo-gt/nixos-config/home.nix
        }

        # Rebuild NixOS system
        nix-rebuild() {
          sudo nixos-rebuild switch --flake /home/togo-gt/nixos-config#togo-gt
        }

        # Rebuild Home Manager
        hm-rebuild() {
          home-manager switch --flake /home/togo-gt/nixos-config#togo-gt
        }

        # Update everything: flake, NixOS, and Home Manager
        update-all() {
          echo "🔄 Updating flake inputs..."
          nix flake update /home/togo-gt/nixos-config

          echo "🚀 Rebuilding NixOS..."
          sudo nixos-rebuild switch --flake /home/togo-gt/nixos-config#togo-gt

          echo "🏠 Rebuilding Home Manager..."
          home-manager switch --flake /home/togo-gt/nixos-config#togo-gt

          echo "✅ System update complete!"
        }
      '';
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "konsole";

    # ===== REDDIT API RATE LIMITING =====
    PRAW_RATELIMIT_SECONDS = "600";
    REDDIT_API_DELAY = "2";
    REQUESTS_PER_MINUTE = "60";
    HTTP_MAX_RETRIES = "3";
    HTTP_RETRY_DELAY = "5";

    # Go language paths
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";

    # Rust language paths
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # XDG base directories
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    # NixOS configuration paths
    NIXOS_CONFIG = "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = "/home/togo-gt/nixos-config";
  };

  # Add these directories to your PATH
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm/bin"
  ];

  # Custom wrapper for home-manager command
  home.file.".local/bin/hm" = {
    text = ''
      #!/bin/sh
      if [ "$1" = "switch" ]; then
        command home-manager "$@" 2>&1 | sed '/unread and relevant news item/d'
      else
        command home-manager "$@"
      fi
    '';
    executable = true;
  };

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}
