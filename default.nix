let
  username = "antonio";
  sources = import ./npins;
  inputs = import ./inputs.nix;
  nixpkgs = import sources.nixpkgs { };
  utils = import ./utils;
  with-inputs = import ./follows.nix { inherit sources inputs; };
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
          utils
          inputs
          username
          with-inputs
          ;
        pkgs = nixpkgs;
      };
    }).config;
in
self
