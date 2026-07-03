{
  description = "My NixOS configuration Using Tack As dependency pinning and flake flag support";

  outputs =
    { self, ... }@args:
    let
      system = "x86_64-linux";
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      pkgs = import inputs.nixpkgs { inherit system; };
      config = import ./default.nix;

    in
    {
      nixosConfigurations = config.nC or { };
      devShells.${system}.default = import ./shell.nix { inherit pkgs inputs; };
    };
}
