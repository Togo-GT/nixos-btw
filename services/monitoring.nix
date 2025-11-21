# services/monitoring.nix
# System monitoring, logging, and metrics collection
{ config, pkgs, ... }:

{
  # ===== ENHANCED LOGGING CONFIGURATION =====
  services.journald.extraConfig = ''
    # Increase journal storage
    SystemMaxUse=1G
    SystemMaxFileSize=100M
    SystemMaxFiles=10

    # Enable persistent storage
    Storage=persistent

    # Rate limiting
    RateLimitInterval=30s
    RateLimitBurst=1000
  '';

  # ===== SYSTEM METRICS COLLECTION =====
  services.netdata = {
    enable = true;
    config = {
      global = {
        "memory mode" = "dbengine";
        "history" = 86400; # Keep 24 hours of history
      };
    };
  };

  # ===== LOG MANAGEMENT =====
  services.logrotate.enable = true;
}
