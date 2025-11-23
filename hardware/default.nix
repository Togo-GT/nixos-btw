# hardware/default.nix
# Hardware configuration with performance optimizations
{ ... }:

{
  imports = [
    ./gaming-optimization.nix
    # Import hardware-specific configurations if needed
  ];

  # Module imports gaming-optimization.nix to centralize gaming-related tuning.
}
