# /home/togo-gt/nixos-config/environment/lsp.nix
{ ... }:

{
  # Enable nixd LSP
  programs.nixd = {
    enable = true;
    settings = {
      formatting.command = "nixpkgs-fmt";
      options.enable = true;
      eval = {
        enable = true;
        target = {
          args = [ ];
          installable = "";
        };
        # Enable auto archive for flake support
        autoArchive = true;
      };
    };
  };

  # Alternativt, hvis du bruger nil:
  # programs.nil = {
  #   enable = true;
  #   settings = {
  #     formatting.command = [ "nixpkgs-fmt" ];
  #     nix.flake.autoArchive = true;
  #     nix.flake.autoEvalInputs = true;
  #   };
  # };
}
