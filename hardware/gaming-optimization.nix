# hardware/gaming-optimization.nix
# Gaming performance tuning and power management
{ config, pkgs, ... }:

{
  # ===== KERNEL TUNING FOR GAMING =====
  boot.kernelParams = [
    # Add these to your existing kernel parameters
    "pci=pcie_bus_perf"          # PCIe performance
    "mce=ignore_ce"              # Ignore correctable CPU errors
    "processor.max_cstate=1"     # Limit CPU power states for responsiveness
    "intel_idle.max_cstate=0"    # Disable Intel CPU deep sleep states
    "radeon.dpm=0"               # Disable AMD dynamic power management
    "nohpet"                     # Disable HPET for lower latency
  ];

  boot.kernel.sysctl = {
    # Add these to your existing sysctl settings
    # Gaming and real-time performance
    "kernel.sched_rt_runtime_us" = 980000;      # Real-time scheduling
    "vm.compaction_proactiveness" = 0;          # Reduce memory compaction
    "vm.watermark_boost_factor" = 0;            # Faster memory allocation
    "vm.vfs_cache_pressure" = 50;               # Keep more inode/dentry cache

    # Network gaming optimizations
    "net.core.netdev_max_backlog" = 16384;      # Increase network buffer
    "net.core.rmem_max" = 134217728;            # Increase read memory
    "net.core.wmem_max" = 134217728;            # Increase write memory
    "net.ipv4.tcp_rmem" = "4096 87380 134217728"; # TCP read buffer
    "net.ipv4.tcp_wmem" = "4096 87380 134217728"; # TCP write buffer
    "net.ipv4.tcp_congestion_control" = "bbr";  # Better congestion control
  };

  # ===== GAMING-SPECIFIC KERNEL MODULES =====
  boot.kernelModules = [
    # Add these to your existing modules
    "tcp_bbr"                   # Bottleneck Bandwidth and RTT congestion control
    "snd_hrtimer"               # High-resolution timer for audio
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Gaming-related kernel modules
    v4l2loopback               # Already in your config
  ];

  # ===== POWER MANAGEMENT FOR GAMING LAPTOP =====
  services.tlp = {
    enable = true;
    settings = {
      # Keep your existing TLP settings and add:

      # CPU settings for gaming
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU boost settings
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # GPU power management
      RADEON_DPM_PERF_LEVEL_ON_AC = "high";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

      # PCIe power management
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersave";

      # Runtime power management
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  # ===== GAMING PERFORMANCE SERVICES =====
  systemd.services = {
    # Game mode service - enhances performance during gaming
    "gamemode-optimizations" = {
      description = "Apply gaming performance optimizations";
      path = with pkgs; [ bash coreutils ];
      script = ''
        # Set CPU governor to performance
        echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

        # Increase GPU performance limits if available
        if [ -f /sys/class/drm/card0/device/power_dpm_force_performance_level ]; then
          echo high | tee /sys/class/drm/card0/device/power_dpm_force_performance_level
        fi

        # Disable screen blanking during gaming
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.xorg.xset}/bin/xset -dpms
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };

  # ===== CUSTOM GAMING SCRIPTS =====
  environment.systemPackages = with pkgs; [
    # Gaming performance tools
    gamemode
    mangohud
    goverlay
    vkBasalt
  ];

  environment.etc."gamemode.ini".text = ''
    [general]
    ; Gamemode configuration
    desiredgov=performance
    igpu_desiredgov=performance
    softrealtime=auto
    renice=10
    ioprio=0

    [custom]
    ; Custom start commands
    start=systemctl start gamemode-optimizations.service
    end=systemctl stop gamemode-optimizations.service
  '';
}
