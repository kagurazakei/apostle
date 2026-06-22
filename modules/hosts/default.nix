{
  self,
  inputs,
  lib,
  zpkgs,
  ...
}:
let
  nixosSystem = inputs.nixpkgs.lib.nixosSystem;
  buildHost =
    hostname:
    lib.pipe hostname [
      (name: self.modules.hosts.${name})
      (hostModule: {
        inherit hostModule;
        system = hostModule.system or "x86_64-linux";
      })
      (
        { hostModule, system }:
        nixosSystem {
          inherit lib;
          modules = [
            hostModule
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
    ];
  nC = lib.pipe self [
    (x: x.modules.hosts)
    builtins.attrNames
    (hosts: lib.genAttrs hosts buildHost)
  ];
in
{
  inherit nC;
}
