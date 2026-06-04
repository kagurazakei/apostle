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
    in
    nixosSystem {
      modules = with finix.nixosModules; [
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
          ;
      };
    };

  hosts = builtins.attrNames self.modules.hosts;
in
{
  nC = lib.genAttrs hosts mkHost;
}
