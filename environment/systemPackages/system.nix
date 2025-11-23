# System utilities - hardware monitoring, storage, and diagnostics
{ pkgs, ... }:

with pkgs;
[
  # ===== HARDWARE INFORMATION =====
  hwloc # Hardware locality
  powertop # Power consumption monitoring
  acpi # ACPI client utilities
  cpupower-gui # CPU power management GUI
  powerstat # Power consumption measurements
  smartmontools # SMART disk monitoring
  s-tui # Terminal UI for stress testing
  stress-ng # System stress tester
  inxi # System information script
  radeontop # AMD GPU monitoring
  nvitop # GPU process monitoring
  i7z # Intel i7 CPU monitoring

  # ===== STORAGE & FILESYSTEMS =====
  gnome-disk-utility # Disk management GUI
  gparted # Partition editor
  parted # Partition manipulation
  hdparm # Hard disk parameter control
  ncdu # NCurses disk usage
  duf # Disk usage/free utility
  agedu # Disk usage tracking over time
  btrfs-progs # BTRFS filesystem tools
  xfsprogs # XFS filesystem tools
  e2fsprogs # ext2/ext3/ext4 filesystem tools
  mdadm # RAID management
  lvm2 # Logical Volume Manager
  cryptsetup # Disk encryption setup
  nvme-cli # NVMe storage management
  testdisk # Data recovery
  gsmartcontrol # GUI for smartmontools
  ntfs3g # NTFS filesystem support

  # ===== BACKUP SOLUTIONS =====
  borgbackup # Deduplicating backup program
  rsnapshot # Filesystem snapshot backup
  timeshift # System restore tool
  duplicity # Encrypted bandwidth-efficient backup

  # ===== NETWORK TOOLS =====
  wavemon # Wireless network monitor

  # ===== POWER MANAGEMENT =====
  cpufrequtils # CPU frequency scaling
  tlp # Linux power management
  auto-cpufreq # Automatic CPU frequency scaling

  # ===== DIAGNOSTIC TOOLS =====
  strace # System call tracer
  ltrace # Library call tracer
  perf-tools # Linux performance tools
  sysstat # System performance tools
]
