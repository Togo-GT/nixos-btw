# environment/default.nix - FIXED
{ pkgs, lib, ... }:

let
  # Import your package sets from the systemPackages directory
  systemPackages = import ./systemPackages { inherit pkgs lib; };
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

  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;
    allowBroken = false;
    allowUnsupportedSystem = false;
  };
}
