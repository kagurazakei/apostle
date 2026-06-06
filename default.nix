let
  username = "antonio";
  inputs = import ./.tack;
  lib = inputs.nixpkgs.lib;
  nixpkgs = import inputs.nixpkgs { inherit lib; };
  utils = import ./utils;
  modules = {
    imports = utils.recursiveImport {
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
          lib
          utils
          inputs
          username
          ;
        pkgs = nixpkgs;
      };
    }).config;
in
self
