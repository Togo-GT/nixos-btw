# =============================================================================
# HARDWARE KONFIGURATION - MASTER DOKUMENT
# NVIDIA PRIME SYNERGI (Intel + NVIDIA) + KDE Plasma 6 (Wayland)
# =============================================================================
#
# 🎯 KONFIGURATIONSVISION:
# "Et perfekt integreret hardware-økosystem hvor komponenter arbejder i symbiose
# for at levere maksimal ydeevne, stabilitet og energieffektivitet"
#
# 🔧 DESIGNPRINCIPPER:
# 1. Hardware-abstraktion: Maskinen som en samlet enhed, ikke løse komponenter
# 2. Performance-optimering: Automatisk tilpasning til arbejdsbyrde
# 3. Energibevidsthed: Intelligente strømsparemodus uden at ofre ydeevne
# 4. Fremtidssikring: Modulær arkitektur der kan tilpasse sig nye teknologier
#
# 🚀 KERNETEKNOLOGIER:
# - NVIDIA PRIME Sync: Sømløs GPU-kommunikation mellem Intel og NVIDIA
# - Wayland Native: Modern display server for bedre sikkerhed og performance
# - TLP Intelligent Power: Dynamisk strømstyring baseret på brugsmønstre
# =============================================================================

{ config, lib, pkgs, modulesPath, ... }:

{
  # ===========================================================================
  # IMPORTS OG SYSTEMINTEGRATION
  # ===========================================================================
  #
  # 📦 IMPORTS STRATEGI:
  # "Byg bro mellem hardware-detektion og brugerkonfiguration"
  #
  # Teknisk Implementering:
  # - 'not-detected.nix' fungerer som hardware-tolken
  # - Oversætter fysiske komponenter til NixOS-forståelige enheder
  # - Etablerer grundlag for hele systemets hardware-abstraktionslag
  #
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # ===========================================================================
  # FILSYSTEMER - DATAHJEMME OG ADGANGSKONTROL
  # ===========================================================================
  #
  # 🗂️ FILSYSTEM FILOSOFI:
  # "Organiser dataflow som en velplanlagt byinfrastruktur"
  #
  # Arkitektoniske Principper:
  # - Hierarkisk adgang: Root som bycentrum, boot som branddør
  # - Performance-lagring: SSD-optimering for hurtig dataadgang
  # - Fejltolerance: Swap som nødreserve ved hukommelsespres
  #
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5a76834c-63d2-4217-90aa-b0a9e5a660e9";
    fsType = "ext4"; # 🏠 Root partition - systemets hjerte
    options = [ "noatime" "nodiratime" "discard" ];
    # 💾 SSD-optimering:
    # - 'noatime': Fjerner unødvendige access time updates (performance+)
    # - 'nodiratime': Extender ovenstående til directories
    # - 'discard': Aktiverer TRIM for SSD levetidsforlængelse
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7193-58DE";
    fsType = "vfat"; # 🔐 EFI boot partition - systemets vagt
    options = [ "fmask=0077" "dmask=0077" ];
    # 🛡️ Sikkerhedspermissioner:
    # - fmask=0077: Ingen filadgang for gruppe/andre
    # - dmask=0077: Ingen directory-adgang for gruppe/andre
    # - Beskytter boot-modulet mod uautoriseret manipulation
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b4eb1273-3ff3-48e3-9645-b132cc29ba90"; }
    # 💨 Virtuel hukommelsesreserve:
    # - Funktionerer som "nødventil" ved RAM-overbelastning
    # - Forhindrer system-crash ved ekstrem hukommelsesbrug
    # - Behændig swap-management gennem UUID-referencer
  ];

  # ===========================================================================
  # KERNEL & MODULER - SYSTEMETS HJERNESTAMME
  # ===========================================================================
  #
  # 🧠 KERNEL STRATEGI:
  # "Konstruer en adaptiv kernel der forstår dit hardware-økosystem"
  #
  boot.initrd.availableKernelModules = [
    "xhci_pci"    # 🚀 USB 3.0+ controller - højhastigheds dataflow
    "ahci"        # 💾 SATA storage enheder - fast disk-kommunikation
    "nvme"        # ⚡ NVMe SSD - ultra-hurtig storage protokol
    "usb_storage" # 📦 USB storage enheder - ekstern dataadgang
    "sd_mod"      # 🖴 SD kort læser - mobil data-overførsel
  ];
  # 🎯 Initrd Mission:
  # "Skab minimal boot-miljø der kan mounte root filsystemet"

  boot.kernelModules = [
    "kvm-intel"       # 🖥️ Hardware virtualisering - Intel VT-x acceleration
    "nvidia"          # 🎮 NVIDIA GPU driver - grafikkortets stemme
    "nvidia_modeset" # 🖼️ Kernel modesetting - direkte display-kontrol
    "nvidia_uvm"      # 🧩 Unified Video Memory - GPU hukommelsesmanagement
    "nvidia_drm"      # 🎨 Direct Rendering Manager - moderne graphics stack
  ];
  # 🎯 Kernel Modules Mission:
  # "Aktivér avancerede hardware-funktioner efter boot completion"

  boot.extraModulePackages = [ pkgs.linuxPackages_latest.nvidiaPackages.stable ];
  # 📦 Pakke-selektion:
  # - Linux latest: Nyeste kernel features og security patches
  # - NVIDIA stable: Modne, testede GPU-drivers
  # - Perfect balance mellem innovation og stabilitet

  boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" ];
  # 🌉 Filsystem bro-bygning:
  # - ext4: Primary Linux - pålidelig og veltestet
  # - btrfs: Advanced Linux - snapshots og checksumming
  # - vfat: EFI/Windows kompatibilitet - boot samarbejde
  # - ntfs: Windows data-deling - cross-platform harmony

  # ===========================================================================
  # FIRMWARE & CPU - HARDWAREENS SJÆL
  # ===========================================================================
  #
  # ⚡ FIRMWARE FILOSOFI:
  # "Opdater hardwarets indre firmware for at lukke sikkerhedshuller og forbedre ydeevne"
  #
  hardware.enableRedistributableFirmware = true;
  # 🔓 Åben firmware-adgang:
  # - Aktiverer proprietary firmware blobs når nødvendigt
  # - Sikrer komplet hardware-kompatibilitet
  # - Balance mellem open-source idealer og praktiske realiteter

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  # 🧩 CPU microcode opdatering:
  # - Patcher CPU-instructions på hardware-niveau
  # - Fixer security vulnerabilities (Spectre, Meltdown, etc.)
  # - Forbedrer instabilitet og performance issues
  # - Synkroniserer med firmware policy for konsistent adfærd

  # ===========================================================================
  # GRAFIK - DUAL GPU SYNERGI
  # ===========================================================================
  #
  # 🎨 NVIDIA PRIME VISION:
  # "Intel som energieffektiv dagligdags-GPU, NVIDIA som ydeevne-GPU ved behov"
  #
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";   # 🖥️ Intel HD Graphics 530 - integreret GPU
    nvidiaBusId = "PCI:1:0:0";  # 🎮 NVIDIA GTX 960M - dedikeret GPU
  };
  # 🔄 PRIME Sync Magic:
  # - Intel GPU renderer display output
  # - NVIDIA GPU beregner grafik-intensive workloads
  # - Copy-back mechanisme: Data flyder mellem GPU'er uden performance-tab
  # - Brug 'prime-run' kommandoen for at aktivere NVIDIA GPU pr. application

  # ===========================================================================
  # INPUT ENHEDER - BRUGERINTERAKTIONSGRÆNSEFLADE
  # ===========================================================================
  #
  # 🖱️ LIBINPUT MISSION:
  # "Tolker fysiske input-enheder til digitale handlinger med præcision og naturlig følelse"
  #
  services.libinput.enable = true;
  # 🎯 Libinput Features:
  # - Touchpad gesture recognition: Multitouch, swipe, pinch-to-zoom
  # - Smooth scrolling: Inertial scrolling med naturlig følelse
  # - Palm detection: Intelligenter touchpad der ignorerer utilsigtede berøringer
  # - Device-specific tuning: Automatisk optimering pr. enhedstype

  # ===========================================================================
  # STRØM & TERMAL MANAGEMENT - INTELLIGENT ENERGIOPTIMERING
  # ===========================================================================
  #
  # 🔋 POWER MANAGEMENT FILOSOFI:
  # "Dynamisk balance mellem ydeevne og energieffektivitet baseret på kontekst"
  #
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  # 🎛️ CPU Governor Strategi:
  # - 'ondemand': Intelligente frekvenstilpasninger baseret på arbejdsbyrde
  # - Lav belastning: Lav frekvens for at spare batteri
  # - Høj belastning: Max frekvens for maksimal ydeevne
  # - Responsivt: Hurtige frekvensændringer uden mærkbar latency

  services.thermald.enable = true;
  # ❄️ Thermal Daemon Mission:
  # - Proaktiv temperatur-overvågning i realtid
  # - Automatisk throttling ved overophedning
  # - Hardware-beskyttelse mod permanent skade
  # - Collaborerer med CPU governor for optimal termal-ydeevne balance

  # 💡 POWER-PROFILES-DAEMON NOTE:
  # - Konflikt med TLP identificeret og løst
  # - TLP valgt som primær power manager pga. superior laptop-optimering
  # - Se configuration.nix for TLP konfiguration og rational

  # ===========================================================================
  # NETVÆRKSHARDWARE - SYSTEMETS FORBINDELSE TIL VERDENEN
  # ===========================================================================
  #
  # 🌐 NETWORKING STRATEGI:
  # "Automatisk netværkskonfiguration der tilpasser sig ethvert miljø"
  #
  networking.useDHCP = lib.mkDefault true;
  # 🔌 DHCP Intelligence:
  # - Automatisk IP-adresse tilegnelse på ethvert netværk
  # - Zero-config networking: Plug-and-play overalt
  # - Router kompatibilitet: Arbejder med alle moderne routere
  # - NetworkManager overtager detaljeret konfiguration senere
}

# =============================================================================
# SYSTEMETS HARDWARE-JOURNEY: FRA BOOT TIL PRODUCTIVITET
# =============================================================================
#
# BOOT SEKVENS:
# 1. 🚀 EFI fase: Bootloader initialiseres fra /boot
# 2. 🧠 Initrd fase: Kernel modules loades for storage og USB
# 3. 💾 Root mount: Filsystemet mountes og kernel tager over
# 4. 🎨 Graphics init: NVIDIA PRIME konfigureres for display
# 5. 🔋 Power setup: TLP og thermald aktiveres for strømstyring
# 6. 🌐 Networking: DHCP konfigurerer internetforbindelse
# 7. 🖱️ Input ready: Libinput gør enheder klar til bruger
#
# RESULTAT: Et fuldt integreret hardware-økosystem klar til produktivitet!
# =============================================================================
