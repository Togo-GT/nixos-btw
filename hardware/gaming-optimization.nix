# hardware/gaming-optimization.nix
# Gaming performance tuning and power management - flyttet fra configuration.nix
{ config, pkgs, ... }:

{
  # ===== KERNEL TUNING FOR GAMING =====
  boot.kernelParams = [
    # Performance optimizations flyttet fra configuration.nix
    "pci=pcie_bus_perf"          # PCIe performance
    "mce=ignore_ce"              # Ignore correctable CPU errors
    "processor.max_cstate=1"     # Limit CPU power states for responsiveness
    "intel_idle.max_cstate=0"    # Disable Intel CPU deep sleep states
    "nohpet"                     # Disable HPET for lower latency
  ];

  boot.kernel.sysctl = {
    # System optimizations flyttet fra configuration.nix
    "vm.swappiness" = 10;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.vfs_cache_pressure" = 50;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.dirty_expire_centisecs" = 3000;

    # Additional gaming optimizations
    "kernel.sched_rt_runtime_us" = 980000;      # Real-time scheduling
    "vm.compaction_proactiveness" = 0;          # Reduce memory compaction
    "vm.watermark_boost_factor" = 0;            # Faster memory allocation
    "net.core.netdev_max_backlog" = 16384;      # Increase network buffer
    "net.ipv4.tcp_rmem" = "4096 87380 134217728"; # TCP read buffer
    "net.ipv4.tcp_wmem" = "4096 87380 134217728"; # TCP write buffer
    "net.ipv4.tcp_congestion_control" = "bbr";  # Better congestion control
  };

  # ===== GAMING-SPECIFIC KERNEL MODULES =====
  boot.kernelModules = [
    # Additional modules for gaming
    "tcp_bbr"                   # Bottleneck Bandwidth and RTT congestion control
    "snd_hrtimer"               # High-resolution timer for audio
  ];

  # ===== POWER MANAGEMENT FOR GAMING =====
  services.tlp = {
    enable = true;
    settings = {
      # TLP settings flyttet fra configuration.nix
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Additional gaming power settings
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersave";
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
}
