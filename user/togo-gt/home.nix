# /home/togo-gt/nixos-config/home.nix - FIXED VERSION
{ pkgs, ... }:

{
  home.username = "togo-gt";
  home.homeDirectory = "/home/togo-gt";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    file-roller
  ];

  programs = {
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

  # Create a wrapper script that filters out the news message
  home.file.".local/bin/hm" = {
    text = ''
      #!/bin/sh
      if [ "$1" = "switch" ]; then
        # Filter out the news message but show everything else
        command home-manager "$@" 2>&1 | grep -v "unread and relevant news item"
      else
        command home-manager "$@"
      fi
    '';
    executable = true;
  };

  programs.home-manager.enable = true;
}
