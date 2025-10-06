{ ... }:

{
  nix.settings = {
    sandbox = true;
    allowed-users = [ "@wheel" ];
    trusted-users = [ "root" "togo-gt" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
