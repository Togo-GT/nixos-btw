# environment/variables.nix
{ pkgs, ... }:

{
  # System-wide environment variables
  environment.variables = {
    NIX_CONFIG = "experimental-features = nix-command flakes";
  };

  # User session variables
  environment.sessionVariables = {
    # Wayland support for Electron apps
    NIXOS_OZONE_WL = "1";
    # Better performance for some applications
    __GL_THREADED_OPTIMIZATIONS = "1";
    # Vulkan layer path
    VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

    # Your existing variables from configuration.nix
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1";
    GDK_SCALE = "1";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_CONFIG = "/home/togo-gt/nixos-config/configuration.nix";
    NIXOS_FLAKE = "/home/togo-gt/nixos-config";

    # Common shell configurations that apply to both
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # Variables available in all shells
    BAT_THEME = "TwoDark";
    COLORTERM = "truecolor";
  };
}
