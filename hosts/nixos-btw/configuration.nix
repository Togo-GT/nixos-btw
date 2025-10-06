# =====================================
# MAIN SYSTEM CONFIGURATION
# =====================================
# Misc module: configuration.nix

{ ... }:
{
  # =====================================
  # MODULE IMPORTS
  # =====================================
  imports = [
    # =====================================
    # HOST-SPECIFIC CONFIGURATIONS
    # =====================================
    ../../hosts/nixos-btw/hardware-configuration.nix    # Hardware detection
    ../../hosts/nixos-btw/profiles/togo-gt.nix          # User configuration
    ../../hosts/nixos-btw/profiles/sudo.nix

    # =====================================
    # MISC MODULES
    # =====================================
    ../../modules/misc/fonts.nix                        # Font configuration
    ../../modules/misc/i18n.nix                         # Internationalization settings

    # =====================================
    # PACKAGE CATEGORIES
    # =====================================
    ../../modules/packages/development.nix     # Development environments
    ../../modules/packages/gui-apps.nix        # Graphical applications
    ../../modules/packages/hardware.nix        # Hardware-specific packages
    ../../modules/packages/multimedia.nix      # Media applications
    ../../modules/packages/networking.nix      # Network utilities
    ../../modules/packages/system-tools.nix    # System administration tools

    # =====================================
    # SERVICE CONFIGURATIONS
    # =====================================
    ../../modules/services/graphical.nix        # Display and graphics services
    ../../modules/services/pipewire-audio.nix   # Modern audio system
    ../../modules/services/printing.nix         # Printing service (CUPS)
    ../../modules/services/rtkit.nix            # Realtime audio privileges
    ../../modules/services/services.nix         # System daemons and services
    ../../modules/services/ventoy.nix           # Bootable USB creation tool

    # =====================================
    # SYSTEM-LEVEL CONFIGURATIONS
    # =====================================
    ../../modules/system/audit.nix
    ../../modules/system/boot.nix           # Bootloader and kernel settings
    ../../modules/system/fail2ban.nix
    ../../modules/system/firewall.nix
    ../../modules/system/hardware.nix
    ../../modules/system/kernel.nix
    ../../modules/system/logging.nix
    ../../modules/system/networking.nix     # Network configuration
    ../../modules/system/nix.nix
    ../../modules/system/ssh.nix
    ../../modules/system/stateversion.nix   # System state version lock

  ];
}
