let
  username = "antonio";
  inputs = import ./.tack;
  lib = inputs.nixpkgs.lib;
  nixpkgs = import inputs.nixpkgs { inherit lib; };
  myLibs = import ./utils;
  modules = {
    imports = myLibs.recursiveImport {
      dirs = [
        ./modules
        ./options
      ];
      excludePrefixedWith = [
        "_"
        "+"
      ];
    };
  };
  self =
    (nixpkgs.lib.evalModules {
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
    }).config;
in
self
