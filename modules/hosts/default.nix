{
  self,
  lib,
  inputs,
  ...
}:
let
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;

  mkHost =
    hostname:
    let
      system = self.modules.hosts.${hostname}.system or "x86_64-linux";
    in
    nixosSystem {
      inherit lib;
      modules = [
        self.modules.hosts.${hostname}
        {
          nixpkgs.overlays = import ../../overlays { inherit inputs; };
        }
      ];
      specialArgs = {
        inherit
          self
          inputs
          system
          lib
          ;
      }
      // inputs;
    };

  hosts = builtins.attrNames self.modules.hosts;
in
{
  nC = lib.genAttrs hosts mkHost;
}
