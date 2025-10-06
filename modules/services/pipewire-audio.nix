# =====================================
# PIPEWIRE AUDIO CONFIGURATION
# =====================================
# Services module: pipewire-audio.nix
{ config, pkgs, lib, ... }:
{
  # =====================================
  # PIPEWIRE AUDIO SYSTEM
  # =====================================
  services.pipewire = {
    enable = true;           # Enable PipeWire modern audio server
    alsa.enable = true;      # ALSA integration for legacy applications
    alsa.support32Bit = true; # Support 32-bit ALSA applications
    pulse.enable = true;     # PulseAudio compatibility layer
    jack.enable = true;      # JACK audio connection kit support
  };
}
