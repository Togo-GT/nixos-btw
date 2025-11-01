# /etc/nixos/configuration.nix
# =============================================================================
# NIXOS SYSTEM KONFIGURATION - MASTER DOKUMENT
# =============================================================================
#
# 🎯 SYSTEM VISION:
# "Et personligt, højtydende computing-univers skræddersyet til kreativt arbejde,
# udvikling og gaming - reproducerbart på ethvert kompatibelt hardware"
#
# 🌟 KERNE FILOSOFI:
# - Deklarativ: Beskriv SLUTRESULTATET, ikke processen
# - Atomisk: Hele systemet opdateres i ét hug eller rulles tilbage
# - Reproducerbart: Samme konfiguration = samme system altid
# - Versioneret: Hver tilstand kan genoprettes præcist
#
# 🏗️ SYSTEM ARKITEKTUR:
# 1. Hardware Abstraktion: Oversætter fysiske komponenter til software-enheder
# 2. Bruger Experience: Poleret desktop med produktivitet som fokus
# 3. Udviklings Miljø: Komplet toolchain for moderne softwareudvikling
# 4. Underholdnings Økosystem: Gaming, multimedia og kreative værktøjer
# =============================================================================

{ config, pkgs, lib, ... }:

# =============================================================================
# SEKTION 1: KONFIGURATIONS VARIABLER OG IMPORTS
# =============================================================================
#
# 🔧 KONFIGURATIONS FILOSOFI:
# "Variabler som systemets DNA - de definerer systemets arvemasse og tilpasningsevne"
#
let
  # ---------------------------------------------------------------------------
  # GPU TYPE VARIABEL - GRAFISK ARKITEKTURENS HJERTE
  # ---------------------------------------------------------------------------
  #
  # 🎮 GPU STRATEGI:
  # "Intel til energieffektivitet, NVIDIA til rå ydeevne - intelligent skift mellem dem"
  #
  gpuType = "optimus";
  # 💡 Betydning af "optimus":
  # - Hybrid graphics: Intel integreret GPU + NVIDIA dedikeret GPU
  # - Dynamisk switching: Automatisk GPU-valg baseret på arbejdsbyrde
  # - PRIME technology: Sømløs data-overførsel mellem GPU'er
  # - Perfect for: Bærbare stationer med grafisk intensivt arbejde

in
{
  # ===========================================================================
  # HARDWARE IMPORT - SYSTEMETS FYSISKE FUNDAMENT
  # ===========================================================================
  #
  # 🔌 HARDWARE INTEGRATION:
  # "Oversæt hardware-scanning til forståelige system-enheder"
  #
  imports = [ ./hardware-configuration.nix ];
  # 🛠️ Genereret via: nixos-generate-config --show-hardware-config
  # 📊 Indholder:
  # - Filystem mapping: Mount points og partitioner
  # - Kernel modules: Hardware-specifikke drivere
  # - Device detection: Automatisk enhedsgenkendelse

  # ===========================================================================
  # SEKTION 2: BOOT KONFIGURATION - SYSTEMETS FØDSEL
  # ===========================================================================
  #
  # 🚀 BOOT FILOSOFI:
  # "Fra strømkNAP til produktivitet på sekunder - en elegant opstartsdans"
  #
  boot = {
    # -------------------------------------------------------------------------
    # BOOTLOADER - SYSTEMETS VAGTMEISTER
    # -------------------------------------------------------------------------
    #
    loader.systemd-boot.enable = true;
    # 🎯 systemd-boot Fordele:
    # - Minimalistisk: Kun essentiel kode i EFI partition
    # - Hurtig: Næsten instant boot til kernel
    # - Simpel: Ingen komplekse konfigurationsfiler
    # - Moderne: Native UEFI implementation

    loader.efi.canTouchEfiVariables = true;
    # 🔧 EFI Integration:
    # - Boot entry management: Tilføjer/fjerner NixOS fra boot menu
    # - Secure Boot kompatibilitet: Arbejder med moderne firmware
    # - Multi-boot venlig: Deler graceful med andre OS

    # -------------------------------------------------------------------------
    # KERNEL SELECTION - SYSTEMETS HJERNESTAMME
    # -------------------------------------------------------------------------
    #
    kernelPackages = pkgs.linuxPackages_latest;
    # 🧠 Latest Kernel Rationale:
    # - Hardware support: Nyeste drivers til NVIDIA, NVMe, USB4
    # - Security patches: Beskyttelse mod nye sårbarheder
    # - Performance improvements: Bedre scheduling, I/O optimeringer
    # - Feature updates: Nyeste filesystems, networking stacks

    # -------------------------------------------------------------------------
    # KERNEL PARAMETRE - SYSTEMETS INSTINKKTER
    # -------------------------------------------------------------------------
    #
    kernelParams = [
      "quiet"           # 🤫 Rene boot logs: Kun essentielle fejl vist
      "splash"          # 🎨 Boot splash: Grafisk feedback under opstart
      "nvidia-drm.modeset=1"  # 🖼️ NVIDIA KMS: Direkte rendering fra boot
      "nowatchdog"      # ⏰ Watchdog disable: Forhindrer kernel panics fra hardware
      "tsc=reliable"    # ⚡ TSC som klokke: Præcis tidsmåling til performance
      "nohibernate"     # 💤 Hibernate disable: Undgår suspend/resume issues
      "nvreg_EnableMSI=1"  # 🔄 MSI interrupts: Bedre GPU respons tid
    ];
    # 🎯 Parameter Strategy:
    # "Minimal noise, maximal hardware acceleration"

    # -------------------------------------------------------------------------
    # INITRD MODULES - SYSTEMETS OVERLEVELSESKIT
    # -------------------------------------------------------------------------
    #
    initrd.availableKernelModules = [
      "nvme"       # ⚡ NVMe SSD: Ultra-hurtig storage init
      "xhci_pci"   # 🔌 USB 3.0+: Alle USB enheder klar tidligt
      "ahci"       # 💾 SATA controllers: Traditionel disk support
      "usbhid"     # 🖱️ USB input: Keyboard/mouse til early troubleshooting
      "usb_storage" # 📦 USB storage: Ekstern data-adgang under boot
      "sd_mod"     # 🖴 SD card readers: Mobil data import/export
    ];
    # 🎯 Initrd Mission: "Mount root filesystem under alle omstændigheder"

    # -------------------------------------------------------------------------
    # KERNEL MODULES - SYSTEMETS SANSEORGANS
    # -------------------------------------------------------------------------
    #
    kernelModules = [
      "fuse"          # 🌉 FUSE: User-space filesystems (SSHFS, NTFS-3G)
      "v4l2loopback"  # 🎥 Virtual camera: OBS streaming, video manipulation
      "snd-aloop"     # 🎵 Virtual audio: Audio routing, podcast production
      "nvidia"        # 🎮 NVIDIA core: GPU driver fundament
      "nvidia_modeset" # 🖼️ Display modes: Resolution switching, multi-monitor
      "nvidia_uvm"     # 🧩 Unified memory: GPU RAM management
      "nvidia_drm"     # 🎨 Direct Rendering: Modern graphics stack
    ];
    # 🎯 Module Strategy: "Enable advanced features after root is mounted"
  };

  # ===========================================================================
  # SEKTION 3: HARDWARE KONFIGURATION - MASKINENS KROP
  # ===========================================================================
  #
  # 🔧 HARDWARE VISION:
  # "Få hardwaret til at synge i perfekt harmoni gennem præcis konfiguration"
  #

  # ---------------------------------------------------------------------------
  # NVIDIA GRAFIK - SYSTEMETS ØJNE OG HJERNE
  # ---------------------------------------------------------------------------
  #
  hardware.nvidia = {
    modesetting.enable = true;
    # 🖼️ Modesetting Magic:
    # - Kernel-based display: Fjerner X11 dependency for display init
    # - Wayland native: Fuldt support for moderne display server
    # - Early KMS: GPU klar før graphical environment starter

    powerManagement.enable = false;
    # ⚡ Power Management Note:
    # - Konflikt med PRIME sync: Deaktiveret for stabilitet
    # - TLP overtager: System-wide power management i stedet

    open = false;
    # 🔓 Driver Selection:
    # - Proprietary drivers: Fulde features og performance
    # - Nouveau deaktiveret: Kun for ekstrem open-source purisme

    nvidiaSettings = true;
    # 🎛️ Control Panel:
    # - GUI configuration: Real-time GPU indstillinger
    # - Performance monitoring: Temperatur, usage, clock speeds
    # - Color correction: Gamma, contrast, digital vibrance

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # 📦 Driver Version Strategy:
    # - Stable branch: Testede, pålidelige drivers
    # - Kernel compatibility: Garanteret arbejde med linuxPackages_latest

    # -------------------------------------------------------------------------
    # NVIDIA PRIME - DUAL GPU ORKESTER
    # -------------------------------------------------------------------------
    #
    prime = {
      sync.enable = true;
      # 🔄 PRIME Sync Technology:
      # - Copy-back architecture: NVIDIA renderer → Intel display
      # - Zero performance loss: Fulde NVIDIA power på interne displays
      # - Seamless switching: Ingen restart eller log out required

      offload.enable = false;
      # 🚫 Offload Deaktiveret:
      # - Konflikt med sync mode: Vælg én teknologi
      # - Sync superior: Bedre performance og kompatibilitet

      intelBusId = "PCI:0:2:0";    # 🖥️ Intel HD Graphics 530
      nvidiaBusId = "PCI:1:0:0";   # 🎮 NVIDIA GTX 960M
      # 🔍 Bus ID Mapping:
      # - lspci output: 00:02.0 → PCI:0:2:0
      # - Hardware addressing: Fast mapping uafhængig af boot orden
    };
  };

  # ---------------------------------------------------------------------------
  # CPU MICROCODE - PROCESSORENS VACCINATION
  # ---------------------------------------------------------------------------
  #
  hardware.cpu.intel.updateMicrocode = true;
  # 🛡️ Microcode Mission:
  # - Security patches: Spectre, Meltdown, ZombieLoad fixes
  # - Stability improvements: Bug fixes for specific CPU models
  # - Performance optimizations: Instruction scheduling improvements

  # ---------------------------------------------------------------------------
  # GRAFIK ACCELERATION - VISUEL BEREGNINGS KRAFT
  # ---------------------------------------------------------------------------
  #
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # 🎯 32-bit Support Rationale:
    # - Gaming compatibility: Mange Steam spil kræver 32-bit libs
    # - Legacy applications: Wine, gamle proprietary apps
    # - Multimedia codecs: Visse codec implementations

    # 🚀 64-bit Acceleration Stack:
    extraPackages = with pkgs; [
      libva-vdpau-driver  # 🔄 VA-API → VDPAU translation layer
      libvdpau-va-gl      # 🔄 VDPAU → VA-API translation layer
      mesa                # 🎨 Open-source OpenGL/Vulkan implementation
    ] ++ lib.optionals (gpuType == "nvidia" || gpuType == "optimus") [
      nvidia-vaapi-driver  # 🎬 Hardware video decoding på NVIDIA
    ];

    # 🎮 32-bit Acceleration Stack:
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva            # 📹 Video Acceleration API fundament
      mesa             # 🎨 OpenGL/Vulkan (32-bit variant)
    ] ++ lib.optionals (gpuType == "nvidia" || gpuType == "optimus") [
      nvidia-vaapi-driver  # 🎬 NVIDIA video decode (32-bit)
    ];
  };

  # ---------------------------------------------------------------------------
  # PRINTING SERVICE - FYSISK OUTPUT GATEWAY
  # ---------------------------------------------------------------------------
  #
  services.printing.enable = true;
  # 🖨️ CUPS Integration:
  # - Universal printer support: USB, network, wireless
  # - Driver auto-detection: Plug-and-play setup
  # - IPP Everywhere: Modern printing standard

  # ---------------------------------------------------------------------------
  # AUDIO SYSTEM - LYDESKABT ATMOSFÆRE
  # ---------------------------------------------------------------------------
  #
  security.rtkit.enable = true;
  # ⏱️ Realtime Privileges:
  # - Low-latency audio: Ingen buffer underruns ved professionelt arbejde
  # - Priority scheduling: Audio processer får CPU forrang

  services.pipewire = {
    enable = true;
    # 🎵 PipeWire Vision:
    # "En enkelt audio/video bus der erstatter 20 års accumulated legacy"

    alsa.enable = true;         # 🔌 Kernel audio interface
    alsa.support32Bit = true;   # 🔧 Legacy application support
    pulse.enable = true;        # 🔄 PulseAudio compatibility
    jack.enable = true;         # 🎛️ Professional audio support
  };
  # 🎯 Audio Strategy: "Modern foundation with full legacy support"

  # ---------------------------------------------------------------------------
  # BLUETOOTH - TRÅDLØS PERIPHERI FORBINDELSE
  # ---------------------------------------------------------------------------
  #
  hardware.bluetooth = {
    enable = true;              # 📡 Bluetooth radio activation
    powerOnBoot = true;         # 🔋 Auto-enable på boot
  };
  services.blueman.enable = true;
  # 🎯 Bluetooth Manager: "GUI simplicity for complex wireless management"

  # ===========================================================================
  # SEKTION 4: NETWORKING - SYSTEMETS NERVESYSTEM
  # ===========================================================================
  #
  # 🌐 NETWORKING FILOSOFI:
  # "Intelligent netværksforvaltning der tilpasser sig ethvert miljø automatisk"
  #
  networking = {
    hostName = "nixos-btw";
    # 🏷️ Hostname Strategy:
    # - Identifikation: Genkendeligt på lokalt netværk
    # - SSH access: nem@nixos-btw for enkel remote adgang
    # - Service discovery: Avahi viser tjenester under dette navn

    networkmanager.enable = true;
    # 📶 NetworkManager Features:
    # - Multi-environment: Auto-switching mellem WiFi netværk
    # - VPN integration: OpenVPN, WireGuard, IPSec support
    # - Mobile broadband: 4G/5G dongle management
    # - GUI control: KDE integration for netværksindstillinger
  };

  # ===========================================================================
  # SEKTION 5: INTERNATIONALISERING - KULTURELT FUNDAMENT
  # ===========================================================================
  #
  # 🌍 I18N STRATEGI:
  # "Et system der forstår din kultur, men taler teknologiens universelle sprog"
  #

  # ---------------------------------------------------------------------------
  # TIDSSYNKRONISERING - SYSTEMETS INDRETIMER
  # ---------------------------------------------------------------------------
  #
  time.timeZone = "Europe/Copenhagen";
  # 🕐 Timezone Rationale:
  # - Lokal tid: Korrekt timestamping i filer og logs
  # - Scheduling: Cron jobs kører på forventet tid
  # - International apps: Viser tider korrekt i globale services

  services.timesyncd.enable = true;
  services.timesyncd.servers = [
    "0.dk.pool.ntp.org"    # 🇩🇰 Primær dansk tidsserver
    "1.dk.pool.ntp.org"    # 🇩🇰 Sekundær dansk server
    "2.dk.pool.ntp.org"    # 🇩🇰 Backup dansk server
    "3.dk.pool.ntp.org"    # 🇩🇰 Redundans dansk server
  ];
  # 🎯 NTP Strategy: "Dansk tid med quadruple redundancy"

  # ---------------------------------------------------------------------------
  # SPRØG OG REGIONAL - KULTUREL IDENTITET
  # ---------------------------------------------------------------------------
  #
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    # 🏴‍☠️ Locale Strategy:
    # "Engelsk som teknologisk fundament, dansk som kulturel overflade"

    supportedLocales = [
      "en_DK.UTF-8/UTF-8"  # 🔧 Teknisk/udviklings miljø
      "da_DK.UTF-8/UTF-8"  # 🇩🇰 Dansk brugergrænseflade
    ];

    extraLocaleSettings = {
      LANG = "en_DK.UTF-8";                    # 🔧 System language
      LC_CTYPE = "en_DK.UTF-8";                # 🔠 Character encoding
      LC_NUMERIC = "da_DK.UTF-8";              # 1.000,00 (dansk decimal)
      LC_TIME = "da_DK.UTF-8";                 # 🕐 24-timers format
      LC_MONETARY = "da_DK.UTF-8";             # 💰 DKK currency format
      LC_ADDRESS = "da_DK.UTF-8";              # 🏠 Dansk adresseformat
      LC_IDENTIFICATION = "da_DK.UTF-8";       # 🆔 Regional identification
      LC_MEASUREMENT = "da_DK.UTF-8";          # 📏 Meter, kilogram enheder
      LC_PAPER = "da_DK.UTF-8";                # 📄 A4 paper standard
      LC_TELEPHONE = "da_DK.UTF-8";            # 📞 +45 landekode
      LC_NAME = "da_DK.UTF-8";                 # 👤 Dansk navneformat
    };
  };

  # ---------------------------------------------------------------------------
  # TASTATUR KONFIGURATION - INPUT ENHEDENS SJÆL
  # ---------------------------------------------------------------------------
  #
  services.xserver.xkb = {
    layout = "dk";    # 🇩🇰 Dansk tastatur layout
    variant = "";     # 🔤 Standard variant (ingen specialtaster)
  };
  console.keyMap = "dk-latin1";
  # ⌨️ Keyboard Strategy: "Dansk layout med Latin-1 encoding for konsollen"

  # ===========================================================================
  # SEKTION 6: GRAFISK MILJØ - SYSTEMETS ANSIGT
  # ===========================================================================
  #
  # 🖥️ DESKTOP VISION:
  # "En produktiv, smuk og intuitiv desktop der forstår både arbejde og leg"
  #

  # ---------------------------------------------------------------------------
  # X11 WINDOW SYSTEM - GRAFISK FUNDAMENT
  # ---------------------------------------------------------------------------
  #
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    # 🎯 X11 Rationale:
    # - NVIDIA kompatibilitet: Fulde driver features
    # - Legacy application support: Apps der ikke kører på Wayland endnu
    # - Gaming performance: Proven technology for spil
  };

  # ---------------------------------------------------------------------------
  # MIME TYPE SYSTEM - FIL ASSOCIATION INTELLIGENS
  # ---------------------------------------------------------------------------
  #
  xdg.mime.enable = true;
  # 📁 MIME Type Magic:
  # - File type detection: Automatisk genkendelse af filformater
  # - Application association: Åbn PDF i Okular, billeder i Gwenview
  # - Protocol handling: http:// links i Firefox, mailto: i Thunderbird

  # ---------------------------------------------------------------------------
  # DISPLAY MANAGER - SYSTEMETS DØRVOGTER
  # ---------------------------------------------------------------------------
  #
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # 🎯 SDDM Features:
    # - KDE native: Perfekt integration med Plasma
    # - Theme support: Customizable login screen
    # - Session management: Remember last session, auto-logout
  };

  # ---------------------------------------------------------------------------
  # DESKTOP ENVIRONMENT - BRUGERENS ARBEJDSRUM
  # ---------------------------------------------------------------------------
  #
  services.desktopManager.plasma6.enable = true;
  # 🪟 KDE Plasma 6 Vision:
  # "Et fuldt tilpasseligt, kraftfuldt desktop miljø der respekterer din arbejdsflow"

  # ---------------------------------------------------------------------------
  # XDG PORTAL SYSTEM - APPLICATION INTEGRATION
  # ---------------------------------------------------------------------------
  #
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde  # 🪟 KDE native integration
      xdg-desktop-portal-gtk              # 🐧 GTK application support
    ];
  };
  # 🎯 Portal Strategy: "Sandboxed apps kan stadig interagere med desktop"

  programs.dconf.enable = true;
  # 🔧 DConf Note: "GTK application settings storage - nødvendig for GNOME apps i KDE"

  # ===========================================================================
  # SEKTION 7: BRUGER KONFIGURATION - SYSTEMETS PERSONLIGHED
  # ===========================================================================
  #
  # 👤 USER EXPERIENCE VISION:
  # "En personlig digital assistent der forstår dine vaner og preferencer"
  #

  # ---------------------------------------------------------------------------
  # GIT KONFIGURATION - VERSION CONTROL HJERTE
  # ---------------------------------------------------------------------------
  #
  programs.git = {
    enable = true;
    config = {
      user.name = "Togo-GT";
      user.email = "michael.kaare.nielsen@gmail.com";
      init.defaultBranch = "main";
    };
  };
  # 🔧 Git Setup: "Global konfiguration der gælder for alle repositories"

  # ---------------------------------------------------------------------------
  # Z SHELL - TERMINALENS KRAFTFULDE SJÆL
  # ---------------------------------------------------------------------------
  #
  programs.zsh = {
    enable = true;
    # 🐚 Zsh Philosophy: "Power user shell med intuitiv auto-completion"

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "systemd" "docker" "kubectl" ];
      # 🔌 Plugin Strategy:
      # - git: Branch visning, status, auto-completion
      # - sudo: Double ESC for sudo prefix
      # - systemd: Service management commands
      # - docker: Container management auto-complete
      # - kubectl: Kubernetes orchestration commands

      theme = "agnoster";
      # 🎨 Agnoster Theme Features:
      # - Git integration: Branch og status i prompt
      # - Visual hierarchy: Klar adskillelse af information
      # - Powerline symbols: Smukke ikoner og separators
    };

    autosuggestions.enable = true;     # 🤖 Fish-style forslag
    syntaxHighlighting.enable = true;  # 🎨 Command syntax farver
  };

  # ---------------------------------------------------------------------------
  # BRUGER KONTO - SYSTEMETS EJER
  # ---------------------------------------------------------------------------
  #
  users.users.togo-gt = {
    isNormalUser = true;     # 👤 Regular user (ikke system account)
    description = "Togo-GT"; # 🏷️ Human-readable identifier

    extraGroups = [
      "networkmanager"  # 📶 Netværks konfiguration rettigheder
      "wheel"           # ⚙️ Administrative privileges (sudo)
      "input"           # 🖱️ Input device access (mice, keyboards)
      "docker"          # 🐳 Container management
      "libvirtd"        # 💻 Virtualization management
    ];
    # 🎯 Group Strategy: "Balance mellem funktionalitet og sikkerhed"

    shell = pkgs.zsh;        # 🐚 Default command environment

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPzs4vJf1MW9Go0FzrBlUuqwwYDyDG7kP5KQYkxSplxF michael.kaare.nielsen@gmail.com"
    ];
    # 🔑 SSH Key Strategy: "Ed25519 for security, authorized for remote access"

    packages = with pkgs; [
      kdePackages.kate      # 📝 Advanced text editor
      # thunderbird        # 📧 Email client (kommenteret ud - ikke nødvendig)
    ];
    # 🎯 User Packages: "Applications only this user needs"
  };

  # ---------------------------------------------------------------------------
  # SSH AGENT - NØGLE FORVALTER
  # ---------------------------------------------------------------------------
  #
  programs.ssh.startAgent = true;
  # 🔐 SSH Agent Magic:
  # - Key management: Holder SSH nøgler unlocked i hukommelsen
  # - Single sign-on: Kun én gang adgangskode pr. session
  # - Agent forwarding: Brug lokale nøgler på remote hosts

  # ===========================================================================
  # SEKTION 8: PAKKE MANAGEMENT - SYSTEMETS FORRÅD
  # ===========================================================================
  #
  # 📦 PACKAGE PHILOSOPHY:
  # "Et kurateret univers af software hvor alt er reproducerbart og versioneret"
  #

  nixpkgs.config.allowUnfree = true;
  # 🔓 Unfree Software Policy:
  # - NVIDIA drivers: Proprietary men nødvendige for hardware
  # - Steam gaming: Required for gaming ecosystem
  # - VS Code: Microsoft license men populær editor
  # - Realistic balance: Open-source idealer vs. praktiske behov

  # ---------------------------------------------------------------------------
  # NIX KONFIGURATION - PAKKE MANAGERENS HJERTE
  # ---------------------------------------------------------------------------
  #
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # 🚀 Experimental Features:
    # - nix-command: Forbedret CLI experience
    # - flakes: Reproducerbare, versionerede systemer

    auto-optimise-store = true;
    # 💾 Storage Optimization:
    # - Deduplication: Identiske filer deles mellem pakker
    # - Hard linking: Spar plads uden at kopiere data

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    # 🌐 Binary Cache Strategy:
    # - cache.nixos.org: Officielle NixOS binære pakker
    # - nix-community: Community-maintained packages

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # 🔑 Trust Model: "Only signed binaries from verified sources"
  };

  # ---------------------------------------------------------------------------
  # AUTOMATISK GARBAGE COLLECTION - SYSTEMETS RENGØRING
  # ---------------------------------------------------------------------------
  #
  nix.gc = {
    automatic = true;           # 🤖 Kør automatisk - ingen manuel intervention
    dates = "weekly";           # 📅 Hver uge - regelmæssig vedligeholdelse
    options = "--delete-older-than 7d";  # 🗑️ Fjern pakker ældre end 7 dage
  };
  # 🎯 Garbage Collection Strategy: "Balance mellem rollback ability og disk space"

  # ===========================================================================
  # SYSTEM PAKKEKURATERING - SOFTWARE ØKOSYSTEMET
  # ===========================================================================
  #
  # 🎯 PACKAGE SELECTION PHILOSOPHY:
  # "Hver pakke har en purpose - intet er tilfældigt eller overflødigt"
  #
  environment.systemPackages = with pkgs; [
    # -------------------------------------------------------------------------
    # SYSTEM VÆRKTØJER - OPERATIVETS VÆRKTOJSKASSE
    # -------------------------------------------------------------------------

    # 📁 FIL MANAGEMENT
    broot          # 🌳 Visual file manager med fuzzy search
    dust           # 💨 Intuitiv disk usage - viser største mapper først
    duf            # 📊 Modern disk free - pæn tabel visning
    fselect        # 🔍 Find files with SQL syntax - power user file search
    ncdu           # 📟 NCurses disk usage - klassisk men effektiv
    zoxide         # 🚀 Smart cd - lær dine mapper, hop hurtigt rundt

    # 📝 TEKST PROCESSERING
    bat            # 🦇 Cat med syntax highlighting - moderne fil visning
    bat-extras.batdiff  # 🔄 Diff med farver - bedre code review
    bat-extras.batman   # 📚 Man pages med syntax highlighting
    bat-extras.batpipe  # 📜 Pipe til bat - syntax i alle commands
    micro          # ✨ Modern terminal editor - intuitiv, feature-rich
    neovim         # 🖊️ Vim evolution - extensible, LSP integration
    ripgrep        # 🚀 Ultra-fast grep - regex search på steroider
    ripgrep-all    # 🔍 Multi-format rg - søg i PDF, Word, Markdown
    nil            # 🔧 Nix LSP - intelligent Nix editing

    # 📊 SYSTEM MONITORING
    btop           # 🖥️ Modern resource monitor - beautiful og informativ
    bottom         # 📈 Process monitor - customisable layout
    htop           # 📊 Classic process viewer - tried and tested
    glances        # 👀 Cross-platform monitor - comprehensive overview
    iotop          # 💾 I/O monitoring - disk activity per process
    nethogs        # 🌐 Bandwidth per process - netværks usage
    powertop       # 🔋 Power usage tuning - optimer batteri liv

    # 💾 BACKUP & SYNKRONISERING
    borgbackup     # 🗄️ Deduplicating backup - pladsbesparende versioner
    rsnapshot      # 📸 Filesystem snapshots - point-in-time recovery
    rsync          # 🔄 Versatile file copy - reliable data transfer

    # 🛠️ ALMINDELIGE VÆRKTØJER
    gitFull        # 🔧 Complete Git - med GUI og ekstra features
    curl           # 🌐 Data transfer - HTTP/HTTPS/FTP tool
    curlie         # 🎨 User-friendly curl - syntax highlighting, formatting
    fzf            # 🔍 Fuzzy finder - intelligent fil/command completion
    starship       # 🚀 Customizable prompt - cross-shell, informative
    taskwarrior3   # ✅ Command-line tasks - personal productivity
    tldr           # 📖 Simplified man pages - praktiske eksempler
    tmux           # 🖥️ Terminal multiplexer - session management
    tmuxp          # 🔧 Tmux session manager - automatisk workspace setup
    watch          # ⏰ Execute periodically - automatisér monitoring
    zsh            # 🐚 Z Shell - kraftfuld, skriptbar shell

    # 🔧 SPRØG SERVERS
    nodePackages.bash-language-server  # 🐚 Bash LSP - intelligent shell scripting

    # 🎲 DIVERSE
    aircrack-ng    # 📡 WiFi security - netværks auditing
    cmatrix        # 🌃 Falling code - terminal animation
    file           # 📄 File type detection - magisk fil identification
    fortune        # 💫 Random quotes - terminal inspiration
    openssl        # 🔐 Cryptography toolkit - SSL/TLS implementation

    # -------------------------------------------------------------------------
    # NETVÆRK & SIKKERHED - SYSTEMETS IMMUNSYSTEM
    # -------------------------------------------------------------------------

    # 🌐 NETWORK DIAGNOSTICS
    iperf3         # 📊 Network bandwidth - performance measurement
    nmap           # 🔍 Network discovery - security scanning
    masscan        # 🚀 Mass port scanner - internet-scale scanning
    tcpdump        # 📦 Packet analyzer - low-level traffic inspection
    tcpflow        # 🌊 TCP flow recorder - session reconstruction
    traceroute     # 🗺️ Network path tracing - route visualization

    # 🛡️ SIKKERHED
    ettercap       # 🕵️ MITM attack suite - network security testing
    openvpn        # 🔒 VPN solution - secure remote access
    wireguard-tools # 🚀 Modern VPN - simple, fast, secure

    # 📦 CONTAINERIZATION
    podman         # 🐋 Daemonless containers - rootless, secure

    # -------------------------------------------------------------------------
    # UDVIKLING - SYSTEMETS SKABER VÆRKTØJER
    # -------------------------------------------------------------------------

    # 🏗️ INFRASTRUCTURE AS CODE
    ansible        # 🤖 Configuration management - automation
    packer         # 🖼️ Machine image creation - reproducible builds
    terraform      # 🌍 Infrastructure provisioning - cloud management

    # 🐳 CONTAINERIZATION
    docker         # 📦 Container platform - application packaging
    docker-compose # 🎼 Multi-container management - service orchestration

    # 💻 PROGRAMMERINGSSPROG
    go             # 🐹 Go language - concurrent, compiled
    nodejs         # 🟨 JavaScript runtime - web development
    perl           # 🐪 Perl language - text processing, legacy
    python3        # 🐍 Python 3 - versatile, scientific computing
    python3Packages.pip # 📦 Python package manager - dependency handling
    pipx           # 🚀 Python application installer - isolated apps
    rustup         # 🦀 Rust toolchain manager - systems programming

    # 🔨 BUILD VÆRKTØJER
    cmake          # 🏗️ Build system generator - C/C++ projects
    gcc            # ⚙️ GNU Compiler Collection - essential compiler

    # -------------------------------------------------------------------------
    # GUI APPS - SYSTEMETS ANSIGT UDADTIL
    # -------------------------------------------------------------------------

    # 🌐 BROWSERS & COMMUNICATION
    chromium       # 🔵 Open-source Chrome - web compatibility
    firefox        # 🦊 Privacy-focused browser - customisable
    signal-desktop # 🔒 Secure messaging - encrypted communication
    telegram-desktop # ✈️ Feature-rich messaging - channels, groups
    thunderbird    # 📧 Email client - powerful organization

    # 🎵 MULTIMEDIA
    audacity       # 🎙️ Audio editing - recording, podcast production
    handbrake      # 🎬 Video transcoder - format conversion
    mpv            # 🎥 Media player - minimal, powerful
    spotify        # 🎶 Music streaming - vast library
    vlc            # 📹 Versatile media player - plays everything

    # 🎨 GRAFIK & DESIGN
    gimp           # 🖼️ Image manipulation - Photoshop alternative
    inkscape       # 🖋️ Vector graphics editor - SVG creation
    krita          # 🎨 Digital painting - artist-focused
    kdePackages.okular  # 📚 Document viewer - PDF, EPUB, comics
    zathura        # 📖 Minimalist document viewer - keyboard-driven

    # 🛠️ UTILITIES
    distrobox      # 📦 Containerized environments - distro-agnostic
    kdePackages.dolphin   # 📁 File manager - KDE native, powerful
    evince         # 📄 Document viewer (GNOME) - lightweight
    feh            # 🖼️ Lightweight image viewer - fast, simple
    gparted        # 💾 Partition editor - disk management
    kdePackages.konsole   # 💻 Terminal emulator - feature-rich
    obs-studio     # 🎥 Screen recording/streaming - content creation
    paprefs        # 🔊 PulseAudio preferences - audio routing
    protonup-qt    # 🎮 Proton-GE management - gaming compatibility
    transmission_4-qt # 🌐 BitTorrent client - simple, effective

    # 🎮 GAMING
    lutris         # 🕹️ Game management platform - unified gaming
    wine           # 🍷 Windows compatibility layer - run Windows apps
    wineWowPackages.stable  # 🍾 Nyere Wine - better compatibility
    winetricks     # 🛠️ Wine configuration - component management

    # -------------------------------------------------------------------------
    # HARDWARE & SYSTEM INFO - MASKINENS SELVFORSTÅELSE
    # -------------------------------------------------------------------------

    # 🎮 GPU & GRAFIK
    clinfo         # 💻 OpenCL information - GPU compute capabilities
    mesa-demos     # 🖼️ OpenGL information - includes glxinfo
    vulkan-loader  # 🎯 Vulkan loader - modern graphics API
    vulkan-tools   # 🔧 Vulkan utilities - validation, information

    # 💻 SYSTEM INFORMATION
    dmidecode      # 🔍 Hardware information - BIOS, motherboard
    inxi           # 📊 Comprehensive system info - all hardware
    pciutils       # 🚌 PCI bus utilities - lspci command

    # 💾 STORAGE
    smartmontools  # 📈 Disk health monitoring - SSD/HDD diagnostics
    ntfs3g         # 🔄 NTFS read-write driver - Windows compatibility

    # 🎮 GAMING PERFORMANCE
    gamemode       # 🚀 System optimization for games - performance tuning
    mangohud       # 📊 Performance overlay - FPS, temperatures

    # 🔧 DIVERSE HARDWARE
    libnotify      # 💬 Desktop notifications - alert system
    libva-utils    # 🎬 Video Acceleration utilities - VA-API tools

    # -------------------------------------------------------------------------
    # NIX DEVELOPMENT TOOLS - SYSTEMETS KONFIGURATIONS VÆRKTØJER
    # -------------------------------------------------------------------------
    nix-index          # 🔍 Find packages containing specific files
    nix-search         # 🔎 Search nixpkgs with web interface
    nix-output-monitor # 📊 Enhanced nix-build output with progress
    nix-tree           # 🌳 Interactive dependency tree visualization
    nix-du             # 💾 Analyze nix store disk usage
    nixos-option       # 🔧 Explore NixOS configuration options
    manix              # 📖 Search Nix documentation
    vscode             # 🖋️ Visual Studio Code editor
  ];

  # ===========================================================================
  # SEKTION 9: SYSTEM SERVICES - SYSTEMETS VITALE FUNKTIONER
  # ===========================================================================
  #
  # 🔧 SERVICE PHILOSOPHY:
  # "Automatiserede systemfunktioner der arbejder i baggrunden for din produktivitet"
  #

  # ---------------------------------------------------------------------------
  # STORAGE OPTIMERING - DISKENES SUNDHED
  # ---------------------------------------------------------------------------
  #
  services.fstrim.enable = true;
  # 💾 SSD TRIM Mission:
  # - Garbage collection: Fjerner ugyldige data blokke
  # - Performance maintenance: Forhindrer SSD slowdown over tid
  # - Wear leveling: Forlænger SSD levetid

  # ---------------------------------------------------------------------------
  # MEMORY MANAGEMENT - HUKOMMELSENS BALANCE
  # ---------------------------------------------------------------------------
  #
  services.earlyoom.enable = true;
  # 🧠 Early OOM Strategy:
  # - Proactive killing: Terminerer processer før systemet fryser
  # - User-space first: Bevarer systemstabilitet
  # - Responsive UI: Forhindrer at desktop bliver uresponsiv

  # ---------------------------------------------------------------------------
  # APPLICATION DISTRIBUTION - SOFTWARE LEVERING
  # ---------------------------------------------------------------------------
  #
  services.flatpak.enable = true;
  # 📦 Flatpak Rationale:
  # - Sandboxed apps: Isolerede applikationer for sikkerhed
  # - Cross-distro: Apps der kører på alle Linux distributioner
  # - Proprietary software: Visse apps kun tilgængelige som Flatpak

  # ---------------------------------------------------------------------------
  # POWER MANAGEMENT - STRØMBALANCE KUNST
  # ---------------------------------------------------------------------------
  #
  # 🚫 Deaktiver power-profiles-daemon for at undgå konflikt med TLP
  services.power-profiles-daemon.enable = lib.mkForce false;

  # 🚫 Stop user-level power-profiles-daemon service
  systemd.user.services."power-profiles-daemon" = {
    enable = false;          # ❌ Start ikke user service
    wantedBy = lib.mkForce []; # 🎯 Ingen default targets
  };

  # ---------------------------------------------------------------------------
  # TLP POWER MANAGEMENT - INTELLIGENT ENERGI OPTIMERING
  # ---------------------------------------------------------------------------
  #
  services.tlp = {
    enable = true;            # 🔋 Aktiver TLP power management
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";  # ⚡ Max ydeevne på strøm
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";   # 🔋 Strømbesparelse på batteri
    };
  };
  # 🎯 TLP Strategy: "Automatisk tilpasning til strømkilde for optimal balance"

  # ---------------------------------------------------------------------------
  # GAMING SUPPORT - UNDERHOLDNING ØKOSYSTEM
  # ---------------------------------------------------------------------------
  #
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;    # 🌐 Steam Remote Play
    dedicatedServer.openFirewall = true; # 🖥️ Game server hosting
  };
  programs.gamescope.enable = true;   # 🎮 SteamOS compositor
  programs.gamemode.enable = true;    # 🚀 Gaming performance optimizer
  # 🎯 Gaming Vision: "Console-like experience på PC hardware"

  # ---------------------------------------------------------------------------
  # HARDWARE MONITORING - MASKINENS VITALTEGN
  # ---------------------------------------------------------------------------
  #
  services.hardware.bolt.enable = true;
  # ⚡ Thunderbolt Support:
  # - Hot-plug devices: Eksterne GPU'er, docks, storage
  # - Security policies: Forhindrer uautoriseret enhedsadgang

  # ---------------------------------------------------------------------------
  # VIRTUALISERING - SYSTEMETS MULTIVERSE
  # ---------------------------------------------------------------------------
  #
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;        # 🔒 Rootless containers - sikkerhed
        setSocketVariable = true; # 🔧 DOCKER_HOST environment variable
      };
    };
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;     # 🖥️ Full virtualization - KVM acceleration
        swtpm.enable = true;  # 🔐 Software TPM - Windows 11 support
      };
    };
  };
  # 🎯 Virtualization Strategy: "Containers for apps, VMs for complete systems"

  # ---------------------------------------------------------------------------
  # YDERLIGERE SERVICES - SYSTEMETS STØTTEFUNKTIONER
  # ---------------------------------------------------------------------------
  #
  services = {
    avahi = {           # 🌐 Network service discovery
      enable = true;    # Printer discovery, file sharing
      nssmdns4 = true;  # DNS-based service discovery
    };
    fwupd.enable = true;        # 🔄 Firmware updates - hardware opdateringer
    thermald.enable = true;     # ❄️ Thermal management - overophedningsbeskyttelse
  };

  # ===========================================================================
  # SEKTION 10: FONT KONFIGURATION - SYSTEMETS TYPOGRAFI
  # ===========================================================================
  #
  # 🔤 FONT PHILOSOPHY:
  # "Et komplet skriftsprog der dækker alle sprog, symboler og brugssituationer"
  #
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts            # 🌍 Google's universelle font familie
      noto-fonts-cjk-sans   # 🇯🇵 CJK sans-serif - japansk, kinesisk, koreansk
      noto-fonts-color-emoji      # 😀 Emoji font - fuldfarve emojis
      nerd-fonts.fira-code  # 🔠 Programming font med ligatures
      nerd-fonts.jetbrains-mono # 💻 Programming font - klar, læsevenlig
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
  # 🎯 Font Strategy: "Code clarity, language coverage, and visual appeal"

  # ===========================================================================
  # SEKTION 11: SIKKERHEDSKONFIGURATION - SYSTEMETS FORSVAR
  # ===========================================================================
  #
  # 🛡️ SECURITY PHILOSOPHY:
  # "Låse døre men beholde nøglerne - sikkerhed uden at ofre funktionalitet"
  #

  # ---------------------------------------------------------------------------
  # FJERNADGANGS - SIKKER SSH
  # ---------------------------------------------------------------------------
  #
  services.openssh = {
    enable = true;  # 🌐 SSH server - remote system access
    settings = {
      PasswordAuthentication = false;  # 🔑 Kun nøgle-baseret login
      PermitRootLogin = "no";          # 🚫 Ingen root SSH adgang
    };
  };
  # 🎯 SSH Strategy: "Cryptographic security only - no passwords"

  # ---------------------------------------------------------------------------
  # FIREWALL KONFIGURATION - NETVÆRKETS GRÆNSER
  # ---------------------------------------------------------------------------
  #
  networking.firewall = {
    allowedTCPPorts = [
      22    # 🔐 SSH - secure remote administration
      80    # 🌐 HTTP - web development/testing
      443   # 🔒 HTTPS - secure web development
      27036 # 🎮 Steam - game networking
      27037 # 🎮 Steam - game networking
    ];
    allowedUDPPorts = [
      27031 # 🎮 Steam - voice chat, game data
      27036 # 🎮 Steam - game networking
      3659  # 🎮 Lunar Client (Minecraft) - gaming
    ];
  };
  # 🎯 Firewall Strategy: "Essential services only - minimal attack surface"

  # ---------------------------------------------------------------------------
  # SIKKERHEDSPOLITIKKER - SYSTEMETS LOVE
  # ---------------------------------------------------------------------------
  #
  security = {
    sudo = {
      wheelNeedsPassword = true;  # 🔐 Kræv password for sudo
      execWheelOnly = true;       # 👥 Kun wheel group kan bruge sudo
    };
    protectKernelImage = true;    # 🛡️ Beskyt kernel mod modification
    auditd.enable = true;         # 📊 System auditing - security monitoring
  };
  # 🎯 Security Policy: "Principle of least privilege with full accountability"

  # ===========================================================================
  # SEKTION 12: SYSTEM STATE VERSION - SYSTEMETS TIDSKAPSEL
  # ===========================================================================
  #
  # 🏷️ STATE VERSION PHILOSOPHY:
  # "En tidsstempel der fortæller systemet hvilken æra det tilhører"
  #
  system.stateVersion = "25.05";
  # 💡 State Version Betydning:
  # - Compatibility anchor: Bevarer backward compatibility
  # - Upgrade safety: Sikrer glidende overgange mellem versioner
  # - Configuration stability: Forhindrer uventede ændringer
  # - Never change manually: Kun sæt ved første installation
}

# =============================================================================
# SYSTEMETS LIVSCYKLUS - FRA KONFIGURATION TIL REALITET
# =============================================================================
#
# 🔄 DEPLOYMENT PROCESS:
# $ sudo nixos-rebuild switch --flake .#togo-gt
#   ├── Input Resolution: Downloader nixpkgs og nixos-hardware
#   ├── System Evaluation: Bygger komplet systemkonfiguration
#   ├── Package Building: Kompilerer/downloader alle pakker
#   ├── Service Activation: Stopper/starter services i korrekt rækkefølge
#   └── User Environment: Opdaterer brugerens applikationer
#
# 🎯 ENDELIGE RESULTAT:
# Et komplet, personligt tilpasset computing univers der forstår:
# - Dine hardware preferencer: NVIDIA PRIME, Intel CPU optimering
# - Dine arbejdsvaner: Udvikling, kreativt arbejde, gaming
# - Din kulturelle kontekst: Dansk/engelsk hybrid miljø
# - Din sikkerheds model: Balanceret mellem bekvemmelighed og beskyttelse
#
# =============================================================================
# TAK FOR AT VÆLGE NIXOS - WHERE CONFIGURATION IS KING! 👑
# =============================================================================
