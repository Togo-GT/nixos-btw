{ pkgs, ... }:

with pkgs; [
  # Development tools - COMPLETE suite
  gcc
  gnumake
  pkg-config
  cmake
  gdb
  strace
  ltrace
  valgrind
  shellcheck
  hadolint

  # Programming languages - ALL major languages
  python3
  python3Packages.pip
  pipx
  go
  nodejs
  perl
  rustup
  jdk21

  # Development utilities
  gh
  jq
  yq
  hexyl
  hyperfine
  tokei
  binutils

  # Language servers - COMPLETE LSP setup
  nodePackages.bash-language-server
  nodePackages.typescript-language-server
  nodePackages.vscode-langservers-extracted
  rust-analyzer
  python3Packages.python-lsp-server
  lua-language-server
  marksman
  clang-tools
  haskell-language-server

  # Containers & virtualization - EVERYTHING!
  docker
  docker-compose
  podman
  distrobox
  virt-manager
  virt-viewer
  qemu
  qemu-utils
  qemu_full
  quickemu
  libvirt
  spice
  spice-gtk
  spice-protocol
  spice-vdagent
  vde2
  bridge-utils
  dnsmasq
  OVMF
  virtualbox
  vagrant
  libguestfs
  guestfs-tools
  openvswitch
  virt-top

  # Infrastructure & DevOps
  ansible
  packer
  terraform
  kubernetes-helm
  kubectl

  # Additional development tools
  gnumake
  bear  # compile_commands.json generator
  ctags
  universal-ctags
  cmakeCurses
  ninja
   meson
]
