# =====================================
# HARDWARE OPTIMIZATIONS
# =====================================
{ config, pkgs, lib, ... }:
{
  # Enable all firmware updates
  hardware.enableRedistributableFirmware = true;

  # Bluetooth support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Sensor support
  hardware.sensor.iio.enable = true;

  # PulseAudio fallback (some apps still need it)
  services.pulseaudio.enable = false; # Disabled since using PipeWire

  # Enable support for various controllers
  hardware.xpadneo.enable = true; # Xbox controllers

  # Improve laptop power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
