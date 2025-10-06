# ============================================================
# USER CONFIGURATION MODULE
# ============================================================
# This module configures:
# - Primary user "togo-gt" with proper privileges
# - Root account locking
# - Zsh + Oh My Zsh setup
# - Optional packages for the user
# ============================================================

{ pkgs, ... }:

{
  # ==========================================================
  # ZSH SHELL CONFIGURATION
  # ==========================================================
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [
      "git"
      "sudo"
      "systemd"
      "docker"
      "kubectl"
    ];
    ohMyZsh.theme = "agnoster";
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # ==========================================================
  # NIX TRUSTED USERS
  # ==========================================================
  nix.settings.trusted-users = [ "togo-gt" ];

  # ==========================================================
  # USER ACCOUNTS
  # ==========================================================
  users.users = {
    # Lock root account
    root = {
      hashedPassword = "!";  # Prevent login via password
    };

    # Primary user
    "togo-gt" = {
      isNormalUser = true;
      description = "Togo-GT";

      # Groups for privileges
      extraGroups = [
        "wheel"           # Sudo/admin privileges
        "networkmanager"  # Network management
        "input"           # Input device access
        "docker"          # Docker container management
        "libvirtd"        # Virtualization
      ];

      # Default shell
      shell = pkgs.zsh;

      # Optional user packages
      packages = with pkgs; [
        kdePackages.kate
      ];
    };
  };

  # ==========================================================
  # DISPLAY AND APPLICATION SETTINGS
  # ==========================================================
  services.displayManager.autoLogin.enable = true;
}
