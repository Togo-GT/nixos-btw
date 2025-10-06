{ config, pkgs, lib, ... }:

{
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    logRefusedConnections = true;

    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ ];

    extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 27036 -s 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --dport 27037 -s 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 27031 -s 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 27036 -s 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 3659 -s 192.168.1.0/24 -j nixos-fw-accept
    '';
  };
}
