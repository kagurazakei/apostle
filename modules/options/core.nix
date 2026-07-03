{
  lib,
  pkgs,
  self,
  ...
}:
let
  callPackageWith = lib.callPackageWith;
  callPackage = callPackageWith pkgs;

  paths = {
    dots = ../../dots;
    templates = ../../templates;
    pkgs = ../../pkgs;
    secrets = ../../secrets;
    modules = ../../modules;
  };
in
{
  options.paths = lib.mkOption {
    type = lib.types.attrs;
    description = "Project paths";
    default = { };
  };

  options.modules = lib.mkOption {
    description = "<class>.<aspect> modules. akin to flake-parts' flake.modules";
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = { };
  };

  options.nC = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };

  config.paths = paths;

  config._module.args.zpkgs = lib.filesystem.packagesFromDirectoryRecursive {
    inherit (pkgs) newScope;
    inherit callPackage;
    directory = self.paths.pkgs;
  };
}
