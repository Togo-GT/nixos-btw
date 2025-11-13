#/home/togo-gt/nixos-config/flake.nix
{
  # ===========================================================================
  # FLAKE DOKUMENTATION - SYSTEMETS BLÅPRINT
  # ===========================================================================
  #
  # 🎯 FLAKE VISION:
  # "Et versioneret, reproducerbart og atomisk systemunivers bygget på Nix-teknologi"
  #
  # 📜 FLAKE FILOSOFI:
  # "Deklarativ systemkonstruktion hvor hver konfiguration er en perfekt snapshot
  # af systemets ideelle tilstand - uafhængig af tid og sted"
  #
  description = "NixOS system configuration for togo-gt";

  # ===========================================================================
  # INPUT DEFINITIONER - SYSTEMETS BYGGESTENENE
  # ===========================================================================
  #
  # 📦 INPUT STRATEGI:
  # "Kuratér et økosystem af afhængigheder der sammen skaber et stabilt,
  # men fremsynet operativsystem"
  #
  inputs = {
    # -------------------------------------------------------------------------
    # NIXOS UNSTABLE - GRUNDSTONEN AF SYSTEMET
    # -------------------------------------------------------------------------
    #
    # 🚀 NIXPKGS UNSTABLE MISSION:
    # "Balancen mellem cutting-edge features og industri-stabilitet"
    #
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 💡 Teknisk Rationale:
    # - nixos-unstable: Nyeste software, kernel updates og security patches
    # - Frequent updates: Daglige opdateringer til alle pakker
    # - Rolling release model: Konstant forbedring uden versions-hop
    # - Perfect for: Udviklere, gaming, ny hardware support

    # -------------------------------------------------------------------------
    # NIXOS HARDWARE - BRUG TIL MASKINENS SJÆL
    # -------------------------------------------------------------------------
    #
    # 🔧 HARDWARE REPOSITORY VISION:
    # "Oversætter specifikt hardware til universelle NixOS-moduler"
    #
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # 🎯 Hardware Abstraction Magic:
    # - Community-drevne hardware profiles: Testet og verificeret
    # - Automatisk kernel module konfiguration: Right modules for your hardware
    # - Power management tuning: Optimized for specific device models
    # - Firmware handling: Correct drivers for chipsets and components

    # -------------------------------------------------------------------------
    # HOME-MANAGER - BRUGERMILJØ PERFEKTION
    # -------------------------------------------------------------------------
    #
    # 🏠 HOME-MANAGER MISSION:
    # "Deklarativ konfiguration af brugerens miljø og dotfiles"
    #
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # 🎯 User Environment Magic:
    # - Dotfile management: Version controlled configuration files
    # - User packages: Applications specific to user sessions
    # - Shell configuration: ZSH, Bash, Fish with reproducible settings
    # - GUI application settings: Consistent theming and behavior
  };

  # ===========================================================================
  # OUTPUT DEFINITIONER - SYSTEMETS FÆRDIGE UNIVERS
  # ===========================================================================
  #
  # 🏗️ OUTPUT STRATEGI:
  # "Transformér inputs til et komplet, bootable system med alle dens relationer"
  #
  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs: {
    # =========================================================================
    # NIXOS KONFIGURATIONER - SYSTEMETS MULTIVERSE
    # =========================================================================
    #
    # 🖥️ NIXOSCONFIGURATIONS VISION:
    # "Et landskab af mulige systemtilstande, klar til instantiering"
    #
    nixosConfigurations = {
      # -----------------------------------------------------------------------
      # TOGO-GT SYSTEMDEFINITION - PRIMARY PERSONLIGE ARBEJDSSTATION
      # -----------------------------------------------------------------------
      #
      # 🎯 SYSTEM PROFIL:
      # "En højtydende bærbar station til kreativt arbejde, udvikling og gaming"
      #
      "togo-gt" = nixpkgs.lib.nixosSystem {
        # ---------------------------------------------------------------------
        # SYSTEM ARCHITECTURE - MASKINENS FUNDAMENT
        # ---------------------------------------------------------------------
        #
        system = "x86_64-linux";
        # 🏛️ Arkitekturvalg Rationale:
        # - x86_64: Universel kompatibilitet med al software og hardware
        # - linux: Moderne kernel med omfattende driver support
        # - Perfect match for: NVIDIA GPU, Intel CPU, standard peripherals

        # =====================================================================
        # MODULER - SYSTEMETS ORGANSYSTEMER
        # =====================================================================
        #
        # 🔧 MODUL FILOSOFI:
        # "Saml specialiserede konfigurationsenheder til et helt, funktionelt system"
        #
        modules = [
          # -------------------------------------------------------------------
          # KONFIGURATION.NIX - SYSTEMETS PERSONLIGHED
          # -------------------------------------------------------------------
          #
          # 🎨 BRUGERDEFINERET KONFIGURATION:
          # "Deklarativ beskrivelse af ønsket systemadfærd og brugererfaring"
          #
          ./configuration.nix
          ./zsh-fix.nix          # ✅ KEPT - Your ZSH configuration
          ./packages.nix         # ✅ KEPT - Your package list
          # 📝 Indholdsoverblik:
          # - Boot konfiguration: systemd-boot med UEFI
          # - GPU setup: NVIDIA PRIME med Intel hybrid graphics
          # - Desktop: KDE Plasma 6 på Wayland
          # - User environment: Zsh, Git, development tools
          # - Package ecosystem: 200+ carefully selected applications

          # -------------------------------------------------------------------
          # HARDWARE-CONFIGURATION.NIX - MASKINENS FYSISKE VÆSEN
          # -------------------------------------------------------------------
          #
          # 🔌 HARDWARE AUTODETECTION:
          # "Oversættelse af fysiske komponenter til systemforståelse"
          #
          ./hardware-configuration.nix
          # 🔍 Genereret via: nixos-generate-config --show-hardware-config
          # 📊 Hardware Mapping:
          # - Filesystems: EXT4 root, VFAT boot, swap partion
          # - CPU: Intel microcode updates
          # - GPU: NVIDIA PRIME bus IDs
          # - Kernel modules: Storage, USB, graphics drivers

          # -------------------------------------------------------------------
          # NVIDIA HARDWARE SUPPORT - GRAFISK ACCELERATIONS ENGINE
          # -------------------------------------------------------------------
          #
          # 🎮 NVIDIA COMMUNITY MODUL:
          # "Leverer årelang community-viden om NVIDIA Linux integration"
          #
          nixos-hardware.nixosModules.common-gpu-nvidia
          # 🚀 NVIDIA Optimizations:
          # - Kernel parameter tuning: modeset, DRM, power management
          # - Driver configuration: Proprietary drivers with open components
          # - Wayland support: GBM backend for moderne display server
          # - Power management: Dynamic GPU state management

          # -------------------------------------------------------------------
          # HOME-MANAGER INTEGRATION - BRUGERENS PERSONLIGE UNIVERS
          # -------------------------------------------------------------------
          #
          # 🏠 HOME-MANAGER MODUL:
          # "Deklarativ konfiguration af brugerens miljø og applikationer"
          #
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkg = true;
            home-manager.useUserPackages = true;
            home-manager.users.togo-gt = {
              imports = [ ./home.nix ];
            };
            # 🎯 Home Manager Benefits:
            # - Dotfile management: Version controlled configuration files
            # - User-specific packages: Applications per user
            # - Shell configuration: ZSH, Bash with reproducible settings
            # - GUI application settings: Consistent theming and behavior
          }
        ];

        # 🎯 Module Integration Strategy:
        # "Hierarkisk konfiguration hvor senere moduler overskriver tidligere"
        # 1. Hardware-configuration: Definerer fysiske enheder
        # 2. Configuration.nix: Tilføjer brugerpræferencer og software
        # 3. ZSH-fix.nix: Avanceret shell konfiguration
        # 4. Packages.nix: Komplet pakke økosystem
        # 5. NVIDIA module: Specialiseret GPU optimering
        # 6. Home-manager: Bruger-specifik konfiguration
      };

      # -----------------------------------------------------------------------
      # NIXOS-LIVE ISO SYSTEM - SEPARAT KONFIGURATION
      # -----------------------------------------------------------------------
      #
      # 🎯 ISO SYSTEM PROFIL:
      # "Et live ISO system til installation og recovery med fuld hardware support"
      "nixos-live" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./iso-configuration.nix
        ];
      };
    };
  };
}

# =============================================================================
# FLAKE WORKFLOW - SYSTEMETS LIVSCYKLUS
# =============================================================================
#
# 🔄 BRUGERINTERAKTIONER:
#
# BUILD PROCESS:
# $ sudo nixos-rebuild switch --flake .#togo-gt
#   ├── Input resolution: Downloader nixpkgs og nixos-hardware
#   ├── System evaluation: Evaluérer alle moduler til en enkelt konfiguration
#   ├── Package building: Kompilerer eller downloader alle nødvendige pakker
#   └── Activation: Anvender konfiguration atomisk with rollback mulighed
#
# GARBAGE COLLECTION:
# $ sudo nix-collect-garbage -d
#   └── Fjerner gamle systemgenerationer og ubrugte pakker
#
# UPDATE PROCESS:
# $ nix flake update
#   └── Opdaterer inputs til nyeste commits fra GitHub
#
# ISO BUILD PROCESS:
# $ nix build .#nixosConfigurations.nixos-live.config.system.build.isoImage
#   └── Bygger et live ISO med KDE Plasma 6 og NVIDIA support
#
# =============================================================================
# SYSTEMETS ARKITEKTURPRINCIPPER
# =============================================================================
#
# 1. ✅ REPRODUCIBILITY: Samme flake = samme system uanset hvor eller hvornår
# 2. ✅ DECLARATIVITY: Beskriv HVAD du vil have, ikke HVORDAN du får det
# 3. ✅ COMPOSABILITY: Moduler kan kombineres og genbruges
# 4. ✅ ROLLBACK SAFETY: Enhver tilstand kan gendannes øjeblikkeligt
# 5. ✅ COMMUNITY DRIVEN: Bygger på årtiers NixOS community erfaring
# 6. ✅ ISO BUILDER: sudo nix build .#nixosConfigurations.nixos-live.config.system.build.isoImage --out-link /home/togo-gt/Iso/nixos-live.iso
#
# =============================================================================
