{
  self,
  inputs,
  lib,
  zpkgs,
  ...
}:
let
  nixosSystem = inputs.finix.lib.finixSystem;
  mkHost =
    hostname:
    let
      system = self.modules.hosts.${hostname}.system or "x86_64-linux";
      channelOverlay = final: prev: {
        inherit stable master;
        inherit (prev.stdenv.hostPlatform) system;
      };
      stable = import inputs.stable {
        inherit system;
        config.allowUnfree = true;
      };

      master = import inputs.master {
        inherit system;
        config.allowUnfree = true;
      };
      basepkgs = import inputs.nixpkgs {
        inherit system zpkgs;
        config.allowUnfree = true;
        overlays = [
          inputs.niri-nix.overlays.niri-nix
          inputs.nix-cachyos-kernel.overlays.pinned
          inputs.neovim-nightly.overlays.default
          channelOverlay
        ];
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
        inputs.community-modules.nixosModules.laptop
      ]
      ++ (builtins.attrValues inputs.finix.nixosModules);
      specialArgs = {
        inherit
          zpkgs
          self
          inputs
          system
          ;
        modulesPath = toString inputs.nixpkgs + "/nixos/modules";
      }
      // inputs;
    };

  hosts = builtins.attrNames self.modules.hosts;
in
{
  nC = lib.genAttrs hosts mkHost;
}
