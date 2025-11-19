{ pkgs, ... }:

with pkgs; [
  # ===== COMPILERS & TOOLCHAINS =====
  gcc                     # GNU Compiler Collection
  # gcc-arm-embedded        # ARM embedded GCC - FJERNET (ikke tilgængelig)
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
  # buck2                   # Meta build system - FJERNET (ikke tilgængelig)
  gradle                  # Java build system
  maven                   # Java project management
  sbt                     # Scala build tool
  rebar3                  # Erlang build tool
  # mix                     # Elixir build tool - FJERNET (ikke tilgængelig)
  # cargo                   # Rust package manager - ALLEREDE TILFØJET
  stack                   # Haskell development tool

  # ===== DEBUGGING & ANALYSIS =====
  gdb                     # GNU Debugger
  strace                  # System call tracer
  ltrace                  # Library call tracer
  valgrind                # Memory debugging/profiling
  perf-tools              # Linux performance tools
  sysdig                  # System troubleshooting
  bpftrace                # eBPF tracing
  # systemtap               # System probing - FJERNET (ikke tilgængelig)
  # lttng-ust               # Linux tracing - FJERNET (ikke tilgængelig)

  # ===== CODE QUALITY & LINTING =====
  shellcheck              # Shell script analysis
  hadolint                # Dockerfile linter
  checkbashisms           # Bash portability check
  shfmt                   # Shell formatter
  yamllint                # YAML linter
  # jsonlint                # JSON validator - FJERNET (ikke tilgængelig)
  prettier                # Code formatter
  editorconfig-checker    # EditorConfig compliance

  # ===== PROGRAMMING LANGUAGES =====
  python3                 # Python programming language
  python3Packages.pip     # Python package installer
  pipx                    # Install and run Python applications
  python3Packages.virtualenv # Python virtual environments
  # python3Packages.pipenv  # Python dependency management - FJERNET (brug pipenv i stedet)
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
  # perlPackages.CPAN       # Perl module installer - FJERNET (ikke tilgængelig)
  rustup                  # Rust toolchain installer
  # cargo                   # Rust package manager - ALLEREDE TILFØJET
  jdk21                   # Java Development Kit 21
  # maven                   # Java project management - ALLEREDE TILFØJET
  # gradle                  # Java build tool - ALLEREDE TILFØJET
  scala                   # Scala programming language
  kotlin                  # Kotlin programming language
  groovy                  # Apache Groovy
  ruby                    # Ruby programming language
  # gem                     # Ruby package manager - FJERNET (ikke tilgængelig)
  lua                     # Lua programming language
  luajit                  # Just-in-time Lua compiler
  php                     # PHP programming language
  # composer                # PHP dependency manager
  dotnet-sdk              # .NET SDK
  # fsharp                  # F# programming language - FJERNET (ikke tilgængelig)
  haskellPackages.ghc     # Glasgow Haskell Compiler
  cabal-install           # Haskell build tool
  ocaml                   # OCaml programming language
  opam                    # OCaml package manager
  erlang                  # Erlang programming language
  elixir                  # Elixir programming language
  # gleam                   # Gleam programming language - FJERNET (ikke tilgængelig)
  nim                     # Nim programming language
  zig                     # Zig programming language
  # vlang                   # V programming language - FJERNET (ikke tilgængelig)
  dart                    # Dart programming language
  flutter                 # Flutter SDK
  racket                  # Racket programming language
  guile                   # GNU Guile
  # janet                   # Janet programming language - FJERNET (ikke tilgængelig)

  # ===== DEVELOPMENT UTILITIES =====
  git                     # Distributed version control
  git-lfs                 # Git large file storage
  git-extras              # Additional git commands
  gh                      # GitHub CLI
  # glab                    # GitLab CLI - FJERNET (ikke tilgængelig)
  jq                      # JSON processor
  yq                      # YAML processor
  # xq                      # XML processor - FJERNET (ikke tilgængelig)
  hexyl                   # Hex viewer
  hyperfine               # Command-line benchmarking
  tokei                   # Code metrics
  binutils                # Binary utilities (ld, as, ar)
  radare2                 # Reverse engineering framework
  ghidra                  # Software reverse engineering suite
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
  # gopls                                      # Go LSP - ALLEREDE TILFØJET
  ocamlPackages.ocaml-lsp                    # OCaml LSP
  # elixir-ls                                  # Elixir LSP - FJERNET (ikke tilgængelig)
  # erlang-ls                                  # Erlang LSP - FJERNET (ikke tilgængelig)
  # dart-language-server                       # Dart LSP - FJERNET (ikke tilgængelig)
  # kotlin-language-server                     # Kotlin LSP - FJERNET (ikke tilgængelig)
  # java-language-server                       # Java LSP - FJERNET (ikke tilgængelig)

  # ===== CONTAINERS & VIRTUALIZATION =====
  docker                    # Container platform
  docker-compose            # Multi-container Docker applications
  docker-buildx             # Docker build extensions
  podman                    # Daemonless container engine
  # podman-compose            # Podman compose - FJERNET (ikke tilgængelig)
  buildah                   # OCI image builder
  skopeo                    # Container image utilities
  distrobox                 # Linux container manager
  nixos-container           # NixOS containers
  # systemd-nspawn            # Lightweight container manager

  # ===== FULL VIRTUALIZATION STACK =====
  virt-manager              # Virtual machine manager GUI
  virt-viewer               # Virtual machine viewer
  libvirt                   # Virtualization API
  qemu                      # Machine emulator and virtualizer
  qemu-utils                # QEMU utilities
  # qemu_full                 # Full QEMU feature set - FJERNET (ikke tilgængelig)
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
  # terraform-ls              # Terraform language server - FJERNET (ikke tilgængelig)
  terragrunt                # Terraform wrapper
  kubernetes-helm           # Kubernetes package manager
  kubectl                   # Kubernetes command-line tool
  kubectx                   # Kubernetes context switcher
  k9s                       # Kubernetes CLI management
  kustomize                 # Kubernetes customization
  minikube                  # Local Kubernetes cluster
  kind                      # Kubernetes in Docker
  k3s                       # Lightweight Kubernetes
  # argo-cd                   # GitOps continuous delivery - FJERNET (ikke tilgængelig)
  # fluxcd                    # GitOps toolkit - FJERNET (ikke tilgængelig)
  helmfile                  # Helm deployment manager
  kubeval                   # Kubernetes manifest validation
  kubescape                 # Kubernetes security scanner

  # ===== CLOUD PLATFORMS =====
  awscli2                   # Amazon Web Services CLI
  google-cloud-sdk          # Google Cloud Platform tools
  azure-cli                 # Microsoft Azure CLI
  doctl                     # DigitalOcean CLI
  # linode-cli                # Linode CLI - FJERNET (ikke tilgængelig)
  # vultr-cli                 # Vultr CLI - FJERNET (ikke tilgængelig)
  # ibmcloud-cli              # IBM Cloud CLI - FJERNET (ikke tilgængelig)
  # oracle-cloud-cli          # Oracle Cloud CLI - FJERNET (ikke tilgængelig)

  # ===== DATABASE CLIENTS =====
  sqlite                    # SQLite database
  postgresql                # PostgreSQL database
  mariadb.client             # MySQL client utilities
  mongodb-tools             # MongoDB utilities
  redis                     # Redis in-memory database
  memcached                 # Memcached distributed caching
  # cassandra                 # Apache Cassandra - FJERNET (ikke tilgængelig)
  # couchdb                   # Apache CouchDB - FJERNET (ikke tilgængelig)
  # influxdb                  # Time series database - FJERNET (ikke tilgængelig)
  # clickhouse                # Column-oriented DBMS - FJERNET (ikke tilgængelig)

  # ===== CODE NAVIGATION =====
  ctags                     # Generate tag files for source code
  universal-ctags           # Universal Ctags (maintained fork)
  # gtags                     # GNU global source code tag system - FJERNET (ikke tilgængelig)
  cscope                    # C code browser

  # ===== TESTING TOOLS =====
  k6                        # Performance testing tool
  jmeter                    # Load testing tool
  postman                   # API testing
  insomnia                  # API design platform
  vegeta                    # HTTP load testing tool
  wrk                       # HTTP benchmarking tool
  ab                        # Apache benchmarking tool
  siege                     # HTTP regression testing
]
