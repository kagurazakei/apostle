{
  self,
  inputs,
  lib,
  ...
}:
let
  nixosSystem = inputs.finix.lib.finixSystem;
  mkHost =
    hostname:
    let
      system = self.modules.hosts.${hostname}.system or "x86_64-linux";
      basepkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.niri-nix.overlays.niri-nix
          inputs.nix-cachyos-kernel.overlays.pinned
          inputs.neovim-nightly.overlays.default
          channelOverlay
        ];
      };
      channelOverlay =
        final: prev:
        let
          inherit (prev.stdenv.hostPlatform) system;
        in
        {
          inherit stable master;
          customPackage = if system == "x86_64-linux" then final.hello else final.hello-native;
        };
      stable = import inputs.stable {
        inherit system;
        config.allowUnfree = true;
      };

      master = import inputs.master {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = basepkgs // {
        stable = stable;
        master = master;
      };
    in
    nixosSystem {
      inherit lib;
      modules = [
        {
          nixpkgs.pkgs = inputs.nixpkgs.lib.mkDefault pkgs;
        }
        {
          disabledModules = [ "modules/nixos/appmenu-gtk3-module.nix" ];
        }
        self.modules.hosts.${hostname}
        inputs.community-modules.nixosModules.pipewire
      ]
      ++ builtins.attrValues inputs.finix.nixosModules;

      specialArgs = {
        inherit self inputs system;
        modulesPath = toString inputs.nixpkgs + "/nixos/modules";
      };
    };

  hosts = builtins.attrNames self.modules.hosts;
in
{
  nC = lib.genAttrs hosts mkHost;
}
