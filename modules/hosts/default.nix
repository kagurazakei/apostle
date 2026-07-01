{
  self,
  inputs,
  lib,
  zpkgs,
  system,
  ...
}:
self
|> (x: x.modules.hosts)
|> builtins.attrNames
|> (
  hosts:
  lib.genAttrs hosts (
    hostname:
    hostname
    |> (name: self.modules.hosts.${name})
    |> (
      hostModule:
      inputs.nixpkgs.lib.nixosSystem {
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
  )
)
|> (nC: { inherit nC; })
