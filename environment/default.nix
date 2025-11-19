# environment/default.nix
# Main environment configuration combining system packages and variables
{ pkgs, lib, ... }:

let
  # Import your package sets from the systemPackages directory
  systemPackages = import ./systemPackages/default.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = systemPackages;

  environment.variables = {
    # Wayland support for Electron apps
    NIXOS_OZONE_WL = "1";
    # Better performance for some applications
    __GL_THREADED_OPTIMIZATIONS = "1";
    # Vulkan layer path
    VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
  };

  # TILFØJET: Package Management Optimering
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "root" "togo-gt" ];
    # Ekstra optimeringer
    min-free = 536870912; # 512MB minimum free space
    max-free = 2147483648; # 2GB maximum free space
  };

  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;
    allowBroken = false;
    allowUnsupportedSystem = false;
  };
}
