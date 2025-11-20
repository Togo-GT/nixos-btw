# /home/togo-gt/nixos-config/environment/nixpkgs.nix
{ ... }:

{
  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;
    allowBroken = false;
    allowUnsupportedSystem = false;
    permittedInsecurePackages = [
      "beekeeper-studio-5.3.4"
      "jitsi-meet-1.0.8792"
    ];
  };
}
