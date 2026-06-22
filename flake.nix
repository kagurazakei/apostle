{
  description = "My NixOS configuration Using Tack As dependency pinning and flake flag support";

  outputs =
    { self, ... }@args:
    let
      system = "x86_64-linux"; # Hardcode your system
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      pkgs = import inputs.nixpkgs { inherit system; };
      lib = pkgs.lib;
      config = import ./default.nix {
        inherit
          self
          inputs
          system
          lib
          ;
        nixpkgs = pkgs;
      };
    in
    {
      nixosConfigurations = config.nC;
      devShells.${system}.default = pkgs.mkShell {
        IMPURE = "true";

        buildInputs = with pkgs; [
          git
          npins
          (pkgs.writeShellScriptBin "opt" ''
            npins --lock-file ./dots/neovim/opt-plugins.json "$@"
          '')
          (pkgs.writeShellScriptBin "start" ''
            npins --lock-file ./dots/neovim/start-plugins.json "$@"
          '')
        ];

        shellHook = ''
          export NIX_PATH="nixpkgs=${inputs.nixpkgs}"
          echo "Welcome to the NixOS configuration dev shell!"
          echo "Run 'tack update' to update pinned inputs"
          echo "Available: opt, start, npins"
        '';
      };
    };
}
