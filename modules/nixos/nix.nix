{
  modules.nixos.nix =
    {
      config,
      pkgs,
      nixos-core,
      ...
    }:
    {
      imports = [
        nixos-core.nixosModules.default
      ];
      system.nixos-core = {
        enable = true;
      };
      documentation.enable = false;
      nixpkgs = {
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "librewolf-unwrapped-151.0.2-1"
          "librewolf-151.0.2-1"
          "librewolf-bin-unwrapped-151.0.1-2"
          "librewolf-bin-151.0.1-2"
        ];
        config.problems.handlers = {
          zfs.broken = "ignore"; # or "ignore"
        };
      };
      nix = {
        channel.enable = false;
        nixPath = [ "nixpkgs=/etc/nixos/nixpkgs" ];
        package = pkgs.lixPackageSets.git.lix;
        settings = {
          deprecated-features = [ "broken-string-escape" ];
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operator"
          ];
          builders-use-substitutes = true;
          auto-optimise-store = true;
          require-sigs = true;
          sandbox = true;
          sandbox-fallback = false;
          download-attempts = 3;
          show-trace = true;
          trusted-users = [
            "root"
            "antonio"
            "@wheel"
          ];
          allowed-users = [
            "@wheel"
            "antonio"
            "root"
          ];
          substituters = [
            "https://kagurazakei.cachix.org"
            "https://nix-community.cachix.org"
            "https://heitor.cachix.org"
            "https://attic.xuyh0120.win/lantian"
            "https://hyprland.cachix.org"
            "https://niri-nix.cachix.org"
          ];
          trusted-public-keys = [
            "kagurazakei.cachix.org-1:L150C/szoC/r6LOupCWQRU5IqdWIBl926O1HpiBVEkw="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "heitor.cachix.org-1:IZ1ydLh73kFtdv+KfcsR4WGPkn+/I926nTGhk9O9AxI="
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
          ];
        };

        optimise = {
          automatic = true;
          persistent = true;
          dates = "weekly";
        };

        gc = {
          automatic = false;
          persistent = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
        extraOptions = ''
          allow-import-from-derivation = false
          !include ${config.age.secrets.secret2.path}
          connect-timeout = 60
        '';
      };
    };
}
