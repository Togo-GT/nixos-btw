# If you want Fish shell as an option
{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      # Fish-specific aliases
    };
  };
}
