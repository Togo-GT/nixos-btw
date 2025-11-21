# services/systemd-optimization.nix
# Systemd tuning for faster boot times and better performance
{  pkgs, ... }:

{
  # ===== SYSTEMD OPTIMIZATIONS =====
  systemd = {
    # Use the new settings format instead of extraConfig
    settings = {
      Manager = {
        # Reduce service start timeout
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";

        # Enable parallel service starting
        DefaultTasksMax = "infinity";
      };
    };

    # Service-specific optimizations
    services = {
      # NetworkManager - start early for faster network
      NetworkManager-wait-online = {
        serviceConfig.ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q -t 30" ];
      };

      # Systemd-udev - reduce settle time
      "systemd-udev-settle" = {
        serviceConfig.ExecStart = [ "" "${pkgs.systemd}/bin/udevadm settle -t 10" ];
      };
    };

    # User services for your applications
    user.services = {
      # Auto-start syncthing for user
      syncthing = {
        description = "Syncthing File Synchronization";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.syncthing}/bin/syncthing -no-browser -no-restart -logflags=0";
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "default.target" ];
        environment = {
          STNORESTART = "1";
          HOME = "/home/togo-gt";
        };
      };

      # Reddit API rate limiting service
      reddit-rate-limit = {
        description = "Reddit API Rate Limit Manager";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/echo 'Reddit rate limiting environment configured'";
          RemainAfterExit = true;
        };
        environment = {
          PRAW_RATELIMIT_SECONDS = "600";
          REDDIT_API_DELAY = "2";
        };
        wantedBy = [ "default.target" ];
      };
    };
  };

  # ===== CUSTOM SYSTEMD SERVICES =====
  systemd.services = {
    # Gaming performance service
    "gaming-mode" = {
      description = "Enable gaming performance optimizations";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'";
        ExecStop = "${pkgs.bash}/bin/bash -c 'echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'";
        RemainAfterExit = true;
      };
      wantedBy = [ "multi-user.target" ];
    };

    # System maintenance service
    "system-maintenance" = {
      description = "Weekly system maintenance tasks";
      startAt = "weekly";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.nix}/bin/nix-store --optimise && ${pkgs.nix}/bin/nix-collect-garbage -d'";
        User = "root";
      };
    };
  };
}
