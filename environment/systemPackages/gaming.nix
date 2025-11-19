# Gaming packages - platforms, emulators, and compatibility tools
{ pkgs, ... }:

with pkgs; [
  # ===== GAMING PLATFORMS =====
  steam                    # Steam gaming platform
  heroic                   # Epic Games and GOG launcher
  lutris                   # Open gaming platform
  bottles                  # Easy Wine wrapper
  playonlinux              # Wine frontend
  minigalaxy               # GOG.com client

  # ===== WINE & COMPATIBILITY =====
  wine                     # Windows compatibility layer
  wineWowPackages.stable   # 32-bit and 64-bit Wine
  winetricks               # Wine setup helper
  protontricks             # Proton and Steam tricks

  # ===== GAMING PERFORMANCE TOOLS =====
  mangohud                 # Vulkan/OpenGL overlay for monitoring
  goverlay                 # MangoHud configuration tool
  gamemode                 # Optimize system for gaming

  # ===== EMULATORS =====
  retroarch                # Multi-system emulator frontend
  pcsx2                    # PlayStation 2 emulator
  dolphin-emu              # GameCube and Wii emulator
  mame                     # Multiple Arcade Machine Emulator
  dosbox                   # DOS emulator

  # ===== ADDITIONAL GAMING PLATFORMS =====
  prismlauncher            # Minecraft launcher
  gamescope                # SteamOS compositor
]
