{
  description = "NixOS system configuration for togo-gt";

  # Input definitions - bevar denne kommentar
  inputs = {
    # NixOS unstable channel for latest packages - informativ kommentar
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware configuration support - vigtig kommentar
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # Output definitions - bevar denne kommentar
  outputs = { self, nixpkgs, nixos-hardware }: {
    # NixOS configuration for togo-gt system - informativ kommentar
    nixosConfigurations = {
      # Main system configuration - vigtig kommentar
      "togo-gt" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Modules to include in system configuration - bevar denne kommentar
        modules = [
          # Main system configuration file - informativ kommentar
          ./configuration.nix

          # Hardware-specific configuration - vigtig kommentar
          ./hardware-configuration.nix

          # NVIDIA hardware support if needed - bevar denne kommentar
          nixos-hardware.nixosModules.common-gpu-nvidia
        ];
      };
    };
  };
}
