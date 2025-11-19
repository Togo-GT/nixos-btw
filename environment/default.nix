# environment/default.nix
# Main environment configuration combining system packages and variables
{ pkgs, lib, ... }:

let
  systemPackages = let
    essential = import ./systemPackages/essential.nix { inherit pkgs lib; };
    core = import ./systemPackages/core.nix { inherit pkgs lib; };
    optional = import ./systemPackages/optional.nix { inherit pkgs lib; };
  in
    lib.lists.unique (essential ++ core ++ optional);
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
    allowBroken = true;
    allowUnsupportedSystem = false;
  };
}
