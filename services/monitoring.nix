# services/monitoring.nix
# System monitoring, logging, and metrics collection
{ config, pkgs, ... }:

{
  # ===== ENHANCED LOGGING CONFIGURATION =====
  services.journald = {
    extraConfig = ''
      # Increase journal storage
      SystemMaxUse=1G
      SystemMaxFileSize=100M
      SystemMaxFiles=10

      # Forward to syslog if needed
      ForwardToSyslog=no

      # Enable persistent storage
      Storage=persistent

      # Rate limiting
      RateLimitInterval=30s
      RateLimitBurst=1000
    '';
  };

  # ===== SYSTEM METRICS COLLECTION =====
  services.netdata = {
    enable = true;
    config = {
      global = {
        # Netdata configuration
        "memory mode" = "dbengine";
        "history" = 86400; # Keep 24 hours of history
      };

      # Plugin configurations
      "plugin:proc" = {
        "netdata server resources" = "yes";
        "/proc/net/dev" = "yes";
        "/proc/diskstats" = "yes";
      };
    };
  };

  # ===== LOG MANAGEMENT =====
  services.logrotate = {
    enable = true;
    settings = {
      # System log rotation
      "/var/log/*.log" = {
        rotate = 7;
        daily = true;
        missingok = true;
        compress = true;
        delaycompress = true;
      };

      # Application log rotation
      "/home/togo-gt/.local/state/*/logs/*.log" = {
        rotate = 5;
        weekly = true;
        missingok = true;
        compress = true;
      };
    };
  };

  # ===== CUSTOM MONITORING SCRIPTS =====
  systemd.services = {
    # System health monitoring
    "system-health-check" = {
      description = "System Health Monitoring Service";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash /etc/system-health-check.sh";
        User = "root";
      };
      startAt = "hourly";
    };
  };

  environment.etc."system-health-check.sh" = {
    text = ''
      #!/bin/bash
      # System health monitoring script

      LOG_FILE="/var/log/system-health.log"

      echo "[$(date)] System Health Check:" >> $LOG_FILE

      # Check disk space
      echo "Disk Usage:" >> $LOG_FILE
      df -h / /home >> $LOG_FILE

      # Check memory usage
      echo -e "\nMemory Usage:" >> $LOG_FILE
      free -h >> $LOG_FILE

      # Check system load
      echo -e "\nSystem Load:" >> $LOG_FILE
      uptime >> $LOG_FILE

      # Check critical services
      echo -e "\nService Status:" >> $LOG_FILE
      systemctl is-active NetworkManager && echo "NetworkManager: ✅" >> $LOG_FILE || echo "NetworkManager: ❌" >> $LOG_FILE
      systemctl is-active docker && echo "Docker: ✅" >> $LOG_FILE || echo "Docker: ❌" >> $LOG_FILE

      echo -e "Health check completed\n" >> $LOG_FILE
    '';
    mode = "0755";
  };

  # ===== ALERTING CONFIGURATION =====
  environment.systemPackages = with pkgs; [
    # Monitoring tools
    htop
    iotop
    nethogs
    smartmontools

    # Log analysis tools
    lnav          # Log file navigator
    jq            # JSON processor for structured logs
    miller        # CSV/JSON/XML processor
  ];
}
