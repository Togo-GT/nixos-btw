# =====================================
# DEVELOPMENT TOOLS CONFIGURATION
# =====================================
{ pkgs, ... }:

let
  devPackages = with pkgs; [
    # =====================================
    # INFRASTRUCTURE AS CODE
    # =====================================
    ansible    # Configuration management and deployment
    packer     # Machine image creation tool
    terraform  # Infrastructure provisioning and management

    # =====================================
    # CONTAINERIZATION
    # =====================================
    docker          # Container platform
    docker-compose  # Multi-container application management
    podman          # Daemonless container engine

    # =====================================
    # PROGRAMMING LANGUAGES
    # =====================================
    go                          # Go programming language
    nodejs                      # JavaScript runtime
    perl                        # Perl programming language
    python3                     # Python 3 interpreter
    python3Packages.pip         # Python package installer
    pipx                        # Install and run Python applications in isolated environments
    rustup                      # Rust toolchain installer

    # =====================================
    # BUILD TOOLS AND COMPILERS
    # =====================================
    cmake  # Cross-platform build system generator
    gcc    # GNU Compiler Collection

    # Development tools
    git-crypt
    git-lfs
    tig  # Git terminal UI
  ];
in {
  environment.systemPackages = devPackages;
}
