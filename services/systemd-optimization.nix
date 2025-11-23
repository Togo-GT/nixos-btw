# services/systemd-optimization.nix
# Convert the previous `system-maintenance` service to a systemd.timer-based schedule
# and remove user-level services to avoid duplication with system-level services.
{ pkgs, ... }:

{
  # ===== SYSTEMD OPTIMIZATIONS =====
  systemd = {
    # Use the newer settings structure
    settings = {
      Manager = {
        # Reduce service start/stop timeout for faster failures
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";

        # Allow higher task counts for parallelism
        DefaultTasksMax = "infinity";
      };
    };

    # ===== SYSTEM LEVEL SERVICES =====
    services = {
      "system-maintenance" = {
        description = "Weekly system maintenance tasks (optimize store + garbage collect)";
        path = with pkgs; [
          bash
          nix
        ]; # ensure bash and nix binaries are on $PATH for the service
        serviceConfig = {
          Type = "oneshot";
          # Use bash -e so the command fails early on errors and the journal contains stderr/stdout
          ExecStart = "${pkgs.bash}/bin/bash -e -c '${pkgs.nix}/bin/nix-store --optimise && ${pkgs.nix}/bin/nix-collect-garbage -d'";
          Nice = 10;
          # Keep a conservative restart policy (no restart for oneshot)
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    # ===== TIMERS (schedule the maintenance service) =====
    timers = {
      # Run the above service weekly. `Persistent = true` ensures missed runs (e.g. when machine was off)
      # are executed at next boot.
      "system-maintenance.timer" = {
        description = "Timer to run system-maintenance weekly";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };
  };

  # Note: user-level systemd services were intentionally removed from this module to avoid
  # duplicate/overlapping instances with system-managed services and Home Manager user services.
}
