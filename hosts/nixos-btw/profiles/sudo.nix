{  ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;

    extraConfig = ''
      Defaults secure_path="/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin"
      Defaults passwd_timeout=15
      Defaults timestamp_timeout=15
      Defaults requiretty
      Defaults env_reset
      Defaults env_keep += "SSH_AUTH_SOCK"
      Defaults logfile="/var/log/sudo.log"
      Defaults log_input,log_output
      Defaults use_pty
      Defaults umask=0022
      %wheel ALL=(ALL) ALL
      root ALL=(ALL) ALL
    '';
  };
}
