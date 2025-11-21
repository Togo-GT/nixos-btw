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
  # Most packages are already in system configuration
  home.packages = [
    # Only include packages that are NOT in your system configuration
    # or that you want specific user versions of
  ];

  # Program configurations
  programs = {
    # Git version control setup
    git = {
      enable = true;
      settings = {
        init = {
          defaultBranch = "main";  # Use 'main' as default branch instead of 'master'
        };
        pull = {
          rebase = false;  # Don't use rebase when pulling
        };
        core = {
          editor = "nvim";  # Use Neovim as Git editor
        };
        merge = {
          conflictstyle = "diff3";  # Better merge conflict display
        };
        user = {
          name = "Togo-GT";  # Your Git username
          email = "michael.kaare.nielsen@gmail.com";  # Your Git email
        };
      };
      # Files and folders for Git to ignore
      ignores = [
        ".DS_Store"  # macOS system file
        "*.swp"      # Vim swap files
        "*.swo"      # Vim swap files
        ".direnv/"   # Direnv directories
        "node_modules/"  # Node.js packages
        "__pycache__/"   # Python cache
        "*.pyc"          # Python compiled files
        ".mypy_cache/"   # MyPy cache
        ".pytest_cache/" # Pytest cache
      ];
    };

    # Neovim text editor setup
    neovim = {
      enable = true;
      defaultEditor = true;  # Set as default editor
      viAlias = true;       # Create 'vi' command that points to nvim
      vimAlias = true;      # Create 'vim' command that points to nvim
    };

    # Enable ZSH management with Home Manager
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      # Use initContent instead of initExtra (newer API)
      initContent = ''
        # Rate-limited Reddit API functions
        reddit-curl() {
          local delay=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Calling Reddit API with ''${delay}s delay..."
          curl -H "User-Agent: nixos-script/1.0" "$@"
          sleep "$delay"
        }

        reddit-api() {
          local endpoint="$1"
          local delay=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Calling Reddit API: $endpoint (''${delay}s delay)"
          curl -s "https://www.reddit.com/$endpoint" \
            -H "User-Agent: nixos-script/1.0" \
            -H "Accept: application/json"
          sleep "$delay"
        }

        # Python script wrapper with rate limiting
        rate-limited-python() {
          export PRAW_RATELIMIT_SECONDS=''${PRAW_RATELIMIT_SECONDS:-600}
          export REDDIT_API_DELAY=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Running Python with Reddit rate limiting enabled"
          python3 "$@"
        }
      '';
    };

    # Fuzzy file finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Smart directory jumping
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Pretty command prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;  # Add blank line between commands
        format = "$all";     # Show all prompt sections
        character = {
          success_symbol = "[➜](bold green)";  # Green arrow when commands succeed
          error_symbol = "[➜](bold red)";      # Red arrow when commands fail
        };
      };
    };

    # Better cat command with syntax highlighting
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";              # Color theme
        style = "numbers,changes,header";  # Show line numbers, git changes, headers
        pager = "less -FR";             # Use less as pager with better formatting
      };
    };
  };

  # Background services
  services = {
    syncthing.enable = false;  # Don't use Home Manager's Syncthing (use system service)
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

        # Rate-limited Reddit API functions for ZSH
        reddit-curl() {
          local delay=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Calling Reddit API with ''${delay}s delay..."
          curl -H "User-Agent: nixos-script/1.0" "$@"
          sleep "$delay"
        }

        reddit-api() {
          local endpoint="$1"
          local delay=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Calling Reddit API: $endpoint (''${delay}s delay)"
          curl -s "https://www.reddit.com/$endpoint" \
            -H "User-Agent: nixos-script/1.0" \
            -H "Accept: application/json"
          sleep "$delay"
        }

        rate-limited-python() {
          export PRAW_RATELIMIT_SECONDS=''${PRAW_RATELIMIT_SECONDS:-600}
          export REDDIT_API_DELAY=''${REDDIT_API_DELAY:-2}
          echo "[Rate Limit] Running Python with Reddit rate limiting enabled"
          python3 "$@"
        }
      '';
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";      # Default text editor
    VISUAL = "nvim";      # Default visual editor
    BROWSER = "firefox";  # Default web browser
    TERMINAL = "konsole"; # Default terminal

    # ===== REDDIT API RATE LIMITING =====
    PRAW_RATELIMIT_SECONDS = "600";     # 10 minutes between batches
    REDDIT_API_DELAY = "2";             # 2 seconds between requests
    REQUESTS_PER_MINUTE = "60";         # Max 60 requests per minute
    HTTP_MAX_RETRIES = "3";             # Max retries on failure
    HTTP_RETRY_DELAY = "5";             # 5 seconds between retries
    # =====================================

    # Go language paths
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";

    # Rust language paths
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # XDG base directories (standard locations for config files)
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    # NixOS configuration paths
    NIXOS_CONFIG = "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = "/home/togo-gt/nixos-config";
  };

  # Add these directories to your PATH (where system looks for commands)
  home.sessionPath = [
    "$HOME/.local/bin"    # User's local binaries
    "$HOME/go/bin"        # Go language binaries
    "$HOME/.cargo/bin"    # Rust language binaries
    "$HOME/.npm/bin"      # npm packages
  ];

  # Custom wrapper for home-manager command (filters out news messages)
  home.file.".local/bin/hm" = {
    text = ''
      #!/bin/sh
      if [ "$1" = "switch" ]; then
        # Run home-manager switch but remove news messages
        command home-manager "$@" 2>&1 | sed '/unread and relevant news item/d'
      else
        # For other commands, just run normally
        command home-manager "$@"
      fi
    '';
    executable = true;  # Make this file executable
  };

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}
