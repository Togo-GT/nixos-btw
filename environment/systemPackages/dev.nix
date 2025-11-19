{ pkgs, ... }:

with pkgs; [
  # ===== COMPILERS & BUILD TOOLS =====
  gcc                     # GNU Compiler Collection
  clang                   # LLVM C/C++ compiler
  llvm                    # Low Level Virtual Machine compiler infrastructure
  lldb                    # LLVM debugger
  gnumake                 # GNU make build automation
  pkg-config              # Library configuration tool
  cmake                   # Cross-platform build system
  cmakeCurses             # Curses interface for CMake
  ninja                   # Small build system
  meson                   # Fast build system
  bear                    # compile_commands.json generator
  patchelf                # Modify ELF binaries

  # ===== BUILD SYSTEMS & AUTOTOOLS =====
  autoconf                # Generate configuration scripts
  automake                # Makefile generator
  libtool                 # Library support script
  bazel                   # Google build system
  buck2                   # Meta build system

  # ===== DEBUGGING & ANALYSIS =====
  gdb                     # GNU Debugger
  strace                  # System call tracer
  ltrace                  # Library call tracer
  valgrind                # Memory debugging/profiling

  # ===== CODE QUALITY & LINTING =====
  shellcheck              # Shell script analysis
  hadolint                # Dockerfile linter

  # ===== PROGRAMMING LANGUAGES =====
  python3                 # Python programming language
  python3Packages.pip     # Python package installer
  pipx                    # Install and run Python applications
  python3Packages.virtualenv # Python virtual environments
  pipenv                   # Python dependency management
  poetry                  # Python packaging and dependency management
  go                      # Go programming language
  nodejs                  # JavaScript runtime
  nodePackages_latest.npm # Node.js package manager
  nodePackages_latest.yarn # Fast dependency management
  perl                    # Perl programming language
  rustup                  # Rust toolchain installer
  jdk21                   # Java Development Kit 21
  ruby                    # Ruby programming language
  lua                     # Lua programming language
  php                     # PHP programming language
  dotnet-sdk              # .NET SDK
  haskellPackages.ghc     # Glasgow Haskell Compiler
  ocaml                   # OCaml programming language
  erlang                  # Erlang programming language
  elixir                  # Elixir programming language

  # ===== DEVELOPMENT UTILITIES =====
  gh                      # GitHub CLI
  jq                      # JSON processor
  yq                      # YAML processor
  hexyl                   # Hex viewer
  hyperfine               # Command-line benchmarking
  tokei                   # Code metrics
  binutils                # Binary utilities (ld, as, ar)

  # ===== LANGUAGE SERVERS (LSP) =====
  nodePackages.bash-language-server          # Bash LSP
  nodePackages.typescript-language-server    # TypeScript LSP
  nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON LSP
  rust-analyzer                              # Rust LSP
  python3Packages.python-lsp-server          # Python LSP
  lua-language-server                        # Lua LSP
  marksman                                   # Markdown LSP
  clang-tools                                # Clang-based C/C++ tools
  haskell-language-server                    # Haskell LSP
  pyright                                    # Python LSP (Microsoft)
  ccls                                       # C/C++ LSP
  gopls                                      # Go LSP
  ocamlPackages.ocaml-lsp                    # OCaml LSP

  # ===== CONTAINERS & VIRTUALIZATION =====
  docker                    # Container platform
  docker-compose            # Multi-container Docker applications
  podman                    # Daemonless container engine
  distrobox                 # Linux container manager

  # ===== FULL VIRTUALIZATION STACK =====
  virt-manager              # Virtual machine manager GUI
  virt-viewer               # Virtual machine viewer
  libvirt                   # Virtualization API
  qemu                      # Machine emulator and virtualizer
  qemu-utils                # QEMU utilities
  qemu_full                 # Full QEMU feature set
  quickemu                  # Quick VM creation and management
  spice                     # Remote computing protocol
  spice-gtk                 # SPICE client for GTK
  spice-protocol            # SPICE protocol headers
  spice-vdagent             # SPICE guest agent
  OVMF                      # UEFI firmware for virtual machines
  swtpm                     # Software TPM emulator

  # ===== ADDITIONAL VIRTUALIZATION =====
  vde2                      # Virtual Distributed Ethernet
  bridge-utils              # Ethernet bridge configuration
  dnsmasq                   # DNS forwarder and DHCP server
  virtualbox                # Oracle VirtualBox
  vagrant                   # Development environment management
  libguestfs                # Access and modify VM disk images
  guestfs-tools             # GuestFS command line tools
  openvswitch               # Virtual switch
  virt-top                  # Virtualization performance monitoring

  # ===== INFRASTRUCTURE & DEVOPS =====
  ansible                   # Configuration management
  packer                    # Machine image creation
  terraform                 # Infrastructure as code
  kubernetes-helm           # Kubernetes package manager
  kubectl                   # Kubernetes command-line tool
  kubectx                   # Kubernetes context switcher
  k9s                       # Kubernetes CLI management

  # ===== CLOUD PLATFORMS =====
  awscli2                   # Amazon Web Services CLI
  google-cloud-sdk          # Google Cloud Platform tools
  azure-cli                 # Microsoft Azure CLI

  # ===== DATABASE CLIENTS =====
  sqlite                    # SQLite database
  postgresql                # PostgreSQL database
  mariadb.client             # MySQL client utilities
  mongodb-tools             # MongoDB utilities

  # ===== CODE NAVIGATION =====
  ctags                     # Generate tag files for source code
  universal-ctags           # Universal Ctags (maintained fork)
]
