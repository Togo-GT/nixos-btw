# environment/shell/default.nix
{ ... }:

{
  imports = [
    ./bash.nix
    ./zsh.nix
    ./fish.nix
  ];

}
