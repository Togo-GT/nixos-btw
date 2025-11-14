# /home/togo-gt/nixos-config/home.nix - FIXED VERSION
{ config, pkgs, inputs, ... }:

{
  # ===========================================================================
  # HOME MANAGER CONFIGURATION - BRUGERSPECIFIKT MILJØ
  # ===========================================================================
  home.username = "togo-gt";
  home.homeDirectory = "/home/togo-gt";
  home.stateVersion = "25.05";

  # ===========================================================================
  # PACKAGES - BRUGERSPECIFIKKE PAKKER
  # ===========================================================================
  home.packages = with pkgs; [
    # Development tools
    gh
    git
    vscode-langservers-extracted

    # Utilities
    taskwarrior2
    transmission_4
    nix-diff
    nix-search
    nixos-generators

    # Gaming
    dxvk

    # And packages you need
    libnotify
    p7zip
    pciutils
    usbutils
    lm_sensors
  ];

  # ===========================================================================
  # PROGRAM CONFIGURATION - BRUGERPROGRAMKONFIGURATION
  # ===========================================================================
  programs = {
    # Git configuration - UPDATED TO NEW SYNTAX
    git = {
      enable = true;
      settings = {
        user = {
          name = "Togo-GT";
          email = "michael.kaare.nielsen@gmail.com";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
        core = {
          editor = "nvim";
        };
        merge = {
          conflictstyle = "diff3";
        };
      };
      ignores = [
        ".DS_Store"
        "*.swp"
        "*.swo"
        ".direnv/"
        "node_modules/"
        "__pycache__/"
        "*.pyc"
        ".mypy_cache/"
        ".pytest_cache/"
      ];
    };

    # Neovim configuration
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # 🚨 FIXED: Disable ZSH in Home Manager since it's managed by system configuration
    zsh.enable = false;

    # FZF configuration
    fzf = {
      enable = true;
      # 🚨 FIXED: Disable ZSH integration since ZSH is managed by system
      enableZshIntegration = false;
    };

    # Zoxide configuration (fast directory jumping)
    zoxide = {
      enable = true;
      # 🚨 FIXED: Disable ZSH integration since ZSH is managed by system
      enableZshIntegration = false;
    };

    # Starship prompt
    starship = {
      enable = true;
      # 🚨 FIXED: Disable ZSH integration since ZSH is managed by system
      enableZshIntegration = false;
    };

    # Bat configuration (better cat)
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };
  };

  # ===========================================================================
  # SERVICES - BRUGERSPECIFIKKE TJENESTER
  # ===========================================================================
  services = {
    # Syncthing can be managed per-user with Home Manager
    syncthing = {
      enable = false; # Keep system service, disable user service to avoid conflicts
    };
  };

  # ===========================================================================
  # DOTFILES - BRUGERSPECIFIKKE KONFIGURATIONSFILER
  # ===========================================================================
  home.file = {
    # Create basic directory structure
    ".config/zsh/user-functions.zsh".text = ''
      # User-specific ZSH functions

      # Quick edit for configuration files
      function nix-edit() {
        nvim /home/togo-gt/nixos-config/configuration.nix
      }

      function hm-edit() {
        nvim /home/togo-gt/nixos-config/home.nix
      }

      # Quick rebuild commands
      function nix-rebuild() {
        sudo nixos-rebuild switch --flake /home/togo-gt/nixos-config#togo-gt
      }

      function hm-rebuild() {
        home-manager switch --flake /home/togo-gt/nixos-config#togo-gt
      }

      # Update everything
      function update-all() {
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

  # ===========================================================================
  # SESSION VARIABLES - BRUGERMILJØ VARIABLER
  # ===========================================================================
  home.sessionVariables = {
    # User-specific environment variables
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "konsole";

    # Development
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # XDG Base Directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # ===========================================================================
  # SESSION PATH - BRUGERSPECIFIKKE STIER
  # ===========================================================================
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm/bin"
  ];

  # ===========================================================================
  # HOME MANAGER SELF-MANAGEMENT
  # ===========================================================================
  programs.home-manager.enable = true;
}
