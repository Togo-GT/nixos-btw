{ config, pkgs, lib, ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [ "127.0.0.1/8" "192.168.1.0/24" ];
  };
}
