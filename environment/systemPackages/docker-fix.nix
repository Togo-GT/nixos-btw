# environment/systemPackages/docker-fix.nix
{ pkgs, ... }:

with pkgs; [
  docker
  docker-compose
  docker-buildx
  docker-credential-helpers

  # Language support
  dockerfile-language-server-nodejs
  nodePackages.dockerfile-language-server-nodejs

  # Tools
  dive          # Explore Docker image layers
  ctop          # Container metrics
  lazydocker    # Terminal UI for Docker
]
