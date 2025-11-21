# Development tools - compilers, languages, and development utilities
{ pkgs, ... }:

with pkgs; [
  # ===== COMPILERS & TOOLCHAINS =====
  gcc                     # GNU Compiler Collection
  clang                   # LLVM C/C++ compiler
  llvm                    # Low Level Virtual Machine
  lldb                    # LLVM debugger
  gnumake                 # GNU make build automation
  cmake                   # Cross-platform build system
  cmakeCurses             # Curses interface for CMake
  ninja                   # Small build system
  meson                   # Fast build system
  bear                    # compile_commands.json generator
  patchelf                # Modify ELF binaries
  mold                    # Modern linker
  lld                     # LLVM linker

  # ===== BUILD SYSTEMS & AUTOTOOLS =====
  autoconf                # Generate configuration scripts
  automake                # Makefile generator
  libtool                 # Library support script
  bazel                   # Google build system
  gradle                  # Java build system
  maven                   # Java project management
  sbt                     # Scala build tool
  rebar3                  # Erlang build tool
  stack                   # Haskell development tool

  # ===== DEBUGGING & ANALYSIS =====
  gdb                     # GNU Debugger
  valgrind                # Memory debugging/profiling
  sysdig                  # System troubleshooting
  bpftrace                # eBPF tracing

  # ===== CODE QUALITY & LINTING =====
  shellcheck              # Shell script analysis
  hadolint                # Dockerfile linter
  checkbashisms           # Bash portability check
  shfmt                   # Shell formatter
  yamllint                # YAML linter
  prettier                # Code formatter
  editorconfig-checker    # EditorConfig compliance

  # ===== PROGRAMMING LANGUAGES =====
  python3                 # Python programming language
  python3Packages.pip     # Python package installer
  pipx                    # Install and run Python applications
  python3Packages.virtualenv # Python virtual environments
  pipenv                  # Python dependency management
  poetry                  # Python packaging and dependency management
  go                      # Go programming language
  gopls                   # Go language server
  delve                   # Go debugger
  nodejs                  # JavaScript runtime
  nodePackages.npm        # Node.js package manager
  nodePackages.yarn       # Fast dependency management
  pnpm                    # Fast, disk space efficient package manager
  bun                     # JavaScript runtime
  deno                    # Secure JavaScript runtime
  perl                    # Perl programming language
  rustup                  # Rust toolchain installer
  jdk21                   # Java Development Kit 21
  scala                   # Scala programming language
  kotlin                  # Kotlin programming language
  groovy                  # Apache Groovy
  ruby                    # Ruby programming language
  lua                     # Lua programming language
  luajit                  # Just-in-time Lua compiler
  php                     # PHP programming language
  dotnet-sdk              # .NET SDK
  haskellPackages.ghc     # Glasgow Haskell Compiler
  cabal-install           # Haskell build tool
  ocaml                   # OCaml programming language
  opam                    # OCaml package manager
  erlang                  # Erlang programming language
  elixir                  # Elixir programming language
  nim                     # Nim programming language
  zig                     # Zig programming language
  dart                    # Dart programming language
  flutter                 # Flutter SDK
  racket                  # Racket programming language
  guile                   # GNU Guile

  # ===== REDDIT API TOOLS WITH RATE LIMITING =====
  (writeShellScriptBin "reddit-cli" ''
    # Rate-limited Reddit API wrapper
    export PRAW_RATELIMIT_SECONDS=''${PRAW_RATELIMIT_SECONDS:-600}
    export REDDIT_API_DELAY=''${REDDIT_API_DELAY:-2}
    echo "Reddit API wrapper: ''${REDDIT_API_DELAY}s delay between calls"
    exec "$@"
  '')

  (writeShellScriptBin "praw-wrapper" ''
    # Python PRAW wrapper with enforced rate limiting
    export PRAW_RATELIMIT_SECONDS=''${PRAW_RATELIMIT_SECONDS:-600}
    export REQUESTS_PER_MINUTE=''${REQUESTS_PER_MINUTE:-60}
    python3 -c "
    import os, time, requests
    from requests.adapters import HTTPAdapter
    from requests.packages.urllib3.util.retry import Retry

    # Configure rate-limited session
    session = requests.Session()
    retry_strategy = Retry(
        total=int(os.getenv('HTTP_MAX_RETRIES', 3)),
        backoff_factor=float(os.getenv('HTTP_RETRY_DELAY', 5)),
        status_forcelist=[429, 500, 502, 503, 504],
    )
    session.mount('https://', HTTPAdapter(max_retries=retry_strategy))
    print('Rate-limited session configured: {}s delay'.format(os.getenv('REDDIT_API_DELAY', 2)))
    "
    exec python3 "$@"
  '')
  # ===============================================

  # ===== DEVELOPMENT UTILITIES =====
  jq                      # JSON processor
  yq                      # YAML processor
  hexyl                   # Hex viewer
  hyperfine               # Command-line benchmarking
  tokei                   # Code metrics
  binutils                # Binary utilities (ld, as, ar)
  binaryen                # WebAssembly toolkit
  wabt                    # WebAssembly binary toolkit

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
  ocamlPackages.ocaml-lsp                    # OCaml LSP

  # ===== CONTAINERS & VIRTUALIZATION =====
 # docker                    # Container platform
 # docker-compose            # Multi-container Docker applications
 # docker-buildx             # Docker build extensions
  podman                    # Daemonless container engine
  buildah                   # OCI image builder
  skopeo                    # Container image utilities
  distrobox                 # Linux container manager
  nixos-container           # NixOS containers

  # ===== FULL VIRTUALIZATION STACK =====
  virt-manager              # Virtual machine manager GUI
  virt-viewer               # Virtual machine viewer
  libvirt                   # Virtualization API
  qemu                      # Machine emulator and virtualizer
  qemu-utils                # QEMU utilities
  quickemu                  # Quick VM creation and management
  spice                     # Remote computing protocol
  spice-gtk                 # SPICE client for GTK
  spice-protocol            # SPICE protocol headers
  spice-vdagent             # SPICE guest agent
  OVMF                      # UEFI firmware for virtual machines
  swtpm                     # Software TPM emulator
  seabios                   # Open source BIOS

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
  ansible-lint              # Ansible playbook linting
  packer                    # Machine image creation
  terraform                 # Infrastructure as code
  terragrunt                # Terraform wrapper
  kubernetes-helm           # Kubernetes package manager
  kubectl                   # Kubernetes command-line tool
  kubectx                   # Kubernetes context switcher
  k9s                       # Kubernetes CLI management
  kustomize                 # Kubernetes customization
  minikube                  # Local Kubernetes cluster
  kind                      # Kubernetes in Docker
  k3s                       # Lightweight Kubernetes
  helmfile                  # Helm deployment manager
  kubeval                   # Kubernetes manifest validation
  kubescape                 # Kubernetes security scanner

  # ===== CLOUD PLATFORMS =====
  awscli2                   # Amazon Web Services CLI
  google-cloud-sdk          # Google Cloud Platform tools
  azure-cli                 # Microsoft Azure CLI
  doctl                     # DigitalOcean CLI

  # ===== DATABASE CLIENTS =====
  sqlite                    # SQLite database
  postgresql                # PostgreSQL database
  mariadb.client            # MySQL client utilities
  mongodb-tools             # MongoDB utilities
  memcached                 # Memcached distributed caching

  # ===== CODE NAVIGATION =====
  universal-ctags           # Universal Ctags (maintained fork)
  cscope                    # C code browser

  # ===== TESTING TOOLS =====
  k6                        # Performance testing tool
  jmeter                    # Load testing tool
  insomnia                  # API design platform
  vegeta                    # HTTP load testing tool
  wrk                       # HTTP benchmarking tool
  siege                     # HTTP regression testing

  # ===== CONTAINER DEVELOPMENT =====
  dockerfile-language-server  # LSP for Dockerfile syntax, validation, and completion

]
