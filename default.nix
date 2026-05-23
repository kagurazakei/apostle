let
  sources = import ./npins;
  inputs = import ./inputs.nix;
  nixpkgs = import sources.nixpkgs { };
  utils = import ./utils;
  username = "antonio";
  with-inputs-lib = import sources.with-inputs;
  inputSpec = import ./follows.nix { inherit inputs; };
  flakeResult = with-inputs-lib sources inputSpec (with-inputs: {
    resolved = with-inputs;
  });
  with-inputs = flakeResult.resolved;
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
      modules = [
        modules
      ];
      specialArgs = {
        inherit
          self
          utils
          inputs
          username
          with-inputs
          with-inputs-lib
          ;
        pkgs = nixpkgs;
      };
    }).config
    // {
      paths = {
        dots = ./dots;
        templates = ./templates;
        pkgs = ./pkgs;
        secrets = ./secrets;
      };
    };
in
self
