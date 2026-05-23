{
  lib,
  pkgs,
  self,
  ...
}:
let
  callPackageWith = lib.callPackageWith;
  callPackage = callPackageWith pkgs;
in
{
  options.modules = lib.mkOption {
    description = "<class>.<aspect> modules. akin to flake-parts' flake.modules";
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = { };
  };

  options.nC = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
  config._module.args.zpkgs = lib.filesystem.packagesFromDirectoryRecursive {
    inherit (pkgs) newScope;
    inherit callPackage;
    directory = self.paths.pkgs;
  };
}
