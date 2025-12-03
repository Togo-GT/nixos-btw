# environment/variables.nix
{ pkgs, ... }:

{
  # System-wide environment variables
  environment.variables = {
    NIX_CONFIG = "experimental-features = nix-command flakes";

    # ===== NIX LSP CONFIGURATION =====
    NIXD_AUTO_ARCHIVE = "1"; # Enable auto archive for nixd LSP
    # ================================

    # ===== REDDIT API RATE LIMITING =====
    PRAW_RATELIMIT_SECONDS = "600"; # 10 minutes between batches
    REDDIT_API_DELAY = "2"; # 2 seconds between requests
    REQUESTS_PER_MINUTE = "60"; # Max 60 requests per minute
    HTTP_MAX_RETRIES = "3"; # Max retries on failure
    HTTP_RETRY_DELAY = "5"; # 5 seconds between retries
    # =====================================
  };

  # User session variables
  environment.sessionVariables = {
    # ===== NIX LSP CONFIGURATION =====
    NIXD_AUTO_ARCHIVE = "1"; # Enable auto archive for nixd LSP
    # ================================

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

    # ===== REDDIT RATE LIMITING FOR USER APPS =====
    PRAW_RATELIMIT_SECONDS = "600";
    REDDIT_API_DELAY = "2";
    REQUESTS_TIMEOUT = "30";
    # ==============================================
  };
}
