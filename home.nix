# /home/togo-gt/nixos-config/home.nix - FIXED VERSION
{ config, pkgs, inputs, ... }:

{
  home.username = "togo-gt";
  home.homeDirectory = "/home/togo-gt";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Development
    gh
    git
    vscode-langservers-extracted
    nix-diff
    nix-search
    nixos-generators

    # Utilities
    taskwarrior
    transmission-gtk
    libnotify
    p7zip
    pciutils
    usbutils
    lm_sensors

    # Gaming
    dxvk
    mangohud
    goverlay
  ];

  programs = {
    git = {
      enable = true;
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

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Disable ZSH in Home Manager (managed by system)
    zsh.enable = false;

    fzf = {
      enable = true;
      enableZshIntegration = false; # Managed by system
    };

    zoxide = {
      enable = true;
      enableZshIntegration = false; # Managed by system
    };

    starship = {
      enable = true;
      enableZshIntegration = false; # Managed by system
      settings = {
        add_newline = true;
        format = "$all";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
      };
    };
  };

  services = {
    syncthing.enable = false; # Use system service instead
  };

  home.file = {
    ".config/zsh/user-functions.zsh" = {
      text = ''
        # User-specific ZSH functions

        nix-edit() {
          nvim /home/togo-gt/nixos-config/configuration.nix
        }

        hm-edit() {
          nvim /home/togo-gt/nixos-config/home.nix
        }

        nix-rebuild() {
          sudo nixos-rebuild switch --flake /home/togo-gt/nixos-config#togo-gt
        }

        hm-rebuild() {
          home-manager switch --flake /home/togo-gt/nixos-config#togo-gt
        }

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

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "konsole";

    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    NIXOS_CONFIG = "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = "/home/togo-gt/nixos-config";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm/bin"
  ];

  programs.home-manager.enable = true;
}
