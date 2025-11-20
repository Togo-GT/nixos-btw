# /home/togo-gt/nixos-config/environment/variables.nix
{ pkgs, lib, ... }:

let
  # Helper function to create variable definitions
  mkVar = value: lib.mkDefault value;
in
{
  environment.sessionVariables = {
    # ========== APPLICATION CONFIGURATION ==========

    # Editor & Pager
    EDITOR = mkVar "nvim";
    VISUAL = mkVar "nvim";
    PAGER = mkVar "bat";
    MANPAGER = mkVar "sh -c 'col -bx | bat -l man -p'";

    # Terminal & UI
    BAT_THEME = mkVar "TwoDark";

    # ========== GRAPHICS & DISPLAY ==========

    # Wayland
    MOZ_ENABLE_WAYLAND = mkVar "1";
    NIXOS_OZONE_WL = mkVar "1";  # Electron Wayland support
    SDL_VIDEODRIVER = mkVar "wayland";

    # Scaling & HiDPI
    QT_AUTO_SCREEN_SCALE_FACTOR = mkVar "1";
    QT_SCALE_FACTOR = mkVar "1";
    GDK_SCALE = mkVar "1";

    # Graphics Performance
    __GL_THREADED_OPTIMIZATIONS = mkVar "1";

    # Vulkan
    VK_LAYER_PATH = mkVar "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

    # Java GUI applications
    _JAVA_AWT_WM_NONREPARENTING = mkVar "1";

    # ========== NIXOS SPECIFIC ==========

    # Nix configuration
    NIX_CONFIG = mkVar "experimental-features = nix-command flakes";
    NIXOS_CONFIG = mkVar "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = mkVar "/home/togo-gt/nixos-config";
  };

  # Optional: System-wide environment variables (if needed)
  # environment.variables = {
  #   # Variables that should be available system-wide, not just in user sessions
  #   SYSTEM_VAR = "value";
  # };
}
