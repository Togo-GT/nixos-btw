# /home/togo-gt/nixos-config/home.nix - CORRECTED VERSION
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
  # home.packages = with pkgs; [
    # User-specific packages that don't need system-wide installation

    # Development tools

    # Utilities

    # Media

    # Fun

  #];

  # ===========================================================================
  # PROGRAM CONFIGURATION - BRUGERPROGRAMKONFIGURATION
  # ===========================================================================
  programs = {
    # Git configuration - UPDATED to new syntax
    git = {
      enable = true;
      # 🚨 FIXED: Use new settings structure
      userName = "Togo-GT";
      userEmail = "michael.kaare.nielsen@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "nvim";
        merge.conflictstyle = "diff3";
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

    # ZSH configuration (complements zsh-fix.nix) - UPDATED to correct syntax
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;  # 🚨 FIXED: Keep original name for Home Manager
      syntaxHighlighting.enable = true;

      shellAliases = {
        # Additional user-specific aliases
        nixos-rebuild = "sudo nixos-rebuild";
        hm-rebuild = "home-manager switch";
        nix-gc = "sudo nix-collect-garbage -d";
        nix-optimize = "sudo nix-store --optimize";
        update = "sudo nixos-rebuild switch --flake .#togo-gt && home-manager switch";
      };

      # 🚨 FIXED: Use initExtra for Home Manager
      initExtra = ''
        # User-specific ZSH extras that don't belong in system configuration
        export PATH="$HOME/.local/bin:$PATH"

        # Load user-specific functions
        source $HOME/.config/zsh/user-functions.zsh 2>/dev/null || true

        # Welcome message
        if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
          echo "🔧 Connected to $(hostname) via SSH - Home Manager active"
        fi
      '';
    };

    # FZF configuration
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # Zoxide configuration (fast directory jumping)
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Starship prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
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
    # Create basic directory structure - REMOVED conflicting git ignore file
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

  # ===========================================================================
  # STATE VERSION COMPATIBILITY
  # ===========================================================================
  # home.stateVersion = "25.05";
}
