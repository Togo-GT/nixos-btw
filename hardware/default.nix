# environment/default.nix
{ pkgs, lib, ... }:

let
  # Import your package sets from the systemPackages directory
  systemPackages = import ./hardware {
    inherit pkgs lib;
  };
in
{


}

