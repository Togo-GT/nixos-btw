{ config, pkgs, lib, ... }:

{
  imports = [
    ./systemPackages/default.nix
  ];

  environment.systemPackages = import ./systemPackages { inherit pkgs; };

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

    # Allow packages with broken dependencies (use with caution)
    allowBroken = false;

    # Allow unsupported system packages
    allowUnsupportedSystem = false;
  };
}
