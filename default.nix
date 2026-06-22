{
  inputs,
  lib,
  nixpkgs,
  ...
}:
let
  username = "antonio";
  myLibs = import ./utils;
  self = lib.pipe null [
    (
      _:
      myLibs.recursiveImport {
        dirs = [
          ./modules
          ./options
        ];
        excludePrefixedWith = [
          "_"
          "+"
        ];
      }
    )
    (imports: { imports = imports; })
    (
      modules:
      nixpkgs.lib.evalModules {
        modules = [ modules ];
        specialArgs = {
          inherit
            self
            myLibs
            inputs
            username
            ;
          inherit (nixpkgs) pkgs;
        };
      }
    )
    (result: result.config)
  ];
in
self
