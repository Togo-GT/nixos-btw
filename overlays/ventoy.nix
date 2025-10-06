# overlays.nix
# Custom overlays for NixOS configuration

final: prev: {
  # Make unstable channel available as pkgs.unstable
  unstable = inputs.unstable.legacyPackages.${prev.system};
}
