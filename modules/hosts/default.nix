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
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    nixosSystem {
      modules = [
        { nixpkgs.pkgs = inputs.nixpkgs.lib.mkDefault pkgs; }
        self.modules.hosts.${hostname}
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
