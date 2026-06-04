let
  username = "antonio";
  sources = import ./.tack;
  inputs = import ./.tack;
  lib = inputs.nixpkgs.lib;
  nixpkgs = import sources.nixpkgs { inherit lib; };
  utils = import ./utils;
  # with-inputs = import ./follows.nix { inherit sources inputs; };
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
          sources
          username
          ;
        pkgs = nixpkgs;
      };
    }).config;
in
self
