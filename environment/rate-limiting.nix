# environment/rate-limiting.nix
{ config, pkgs, ... }:

{
  # Systemd services with rate limiting
  systemd.services = {
    # Template for any Reddit-related services
    "reddit-api-service" = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "30min";  # Wait 30 minutes on rate limit errors
        StartLimitIntervalSec = 3600;
        StartLimitBurst = 5;
      };
      environment = {
        PRAW_RATELIMIT_SECONDS = "600";
        REDDIT_API_DELAY = "5";  # Higher delay for services
        MAX_REQUESTS_PER_HOUR = "1000";
      };
    };
  };

  # Network configuration for better API handling
  networking = {
    # TCP keepalive settings (these are valid options)
    extraConfig = ''
      net.ipv4.tcp_keepalive_time = 600
      net.ipv4.tcp_keepalive_intvl = 60
      net.ipv4.tcp_keepalive_probes = 5
    '';
  };

  # Boot kernel parameters for better network performance
  boot.kernel.sysctl = {
    "net.ipv4.tcp_keepalive_time" = 600;
    "net.ipv4.tcp_keepalive_intvl" = 60;
    "net.ipv4.tcp_keepalive_probes" = 5;
  };
}
