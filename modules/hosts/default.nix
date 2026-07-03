{
  self,
  inputs,
  lib,
  zpkgs,
  system,
  ...
}:
self.modules.hosts
|> builtins.attrNames
|> (
  hosts:
  lib.genAttrs hosts (
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      inherit lib;
      modules = [
        self.modules.hosts.${hostname}
        { nixpkgs.overlays = import ../../overlays { inherit inputs; }; }
      ];
      specialArgs = {
        inherit
          self
          inputs
          system
          zpkgs
          ;
      }
      // inputs;
    }
  )
)
|> (nC: { inherit nC; })
