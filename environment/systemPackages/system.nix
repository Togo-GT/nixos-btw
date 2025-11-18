{ pkgs, lib, ... }:

with pkgs; [
  # Hardware information
  hwloc
  powertop
  acpi
  cpupower-gui
  powerstat
  smartmontools
  s-tui
  stress-ng
  inxi

  # Storage & filesystems - EVERY filesystem tool!
  gnome-disk-utility
  gparted
  parted
  hdparm
  ncdu
  duf
  agedu
  rsync
  btrfs-progs
  xfsprogs
  e2fsprogs
  mdadm
  lvm2
  cryptsetup
  nvme-cli
  util-linux
  testdisk
  gsmartcontrol
  ntfs3g
  borgbackup
  rsnapshot
  timeshift
]
