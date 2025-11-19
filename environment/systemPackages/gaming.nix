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
  dxvk                     # DirectX to Vulkan translation
  vkd3d-proton             # Direct3D 12 to Vulkan translation
  vkbasalt                 # Vulkan post processing layer

  # ===== EMULATORS =====
  retroarch                # Multi-system emulator frontend
  pcsx2                    # PlayStation 2 emulator
  dolphin-emu              # GameCube and Wii emulator
  # yuzu                     # Nintendo Switch emulator - FJERNET (ikke tilgængelig)
  # ryujinx                  # Nintendo Switch emulator - FJERNET (ikke tilgængelig)
  # cemu                     # Wii U emulator - FJERNET (ikke tilgængelig)
  mame                     # Multiple Arcade Machine Emulator
  dosbox                   # DOS emulator

  # ===== ADDITIONAL GAMING PLATFORMS =====
  prismlauncher            # Minecraft launcher
  minecraft                # Minecraft game
  gamescope                # SteamOS compositor
  # itch                     # Itch.io game platform - FJERNET (ikke tilgængelig)
  gnome-games              # GNOME games collection
]
