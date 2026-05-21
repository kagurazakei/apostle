let
  sources = import ./npins;
  inputs = import ./inputs.nix;
  nixpkgs = import sources.nixpkgs { };
  utils = import ./utils;
  username = "antonio";
  with-inputs-lib = import sources.with-inputs;

  inputSpec = {
    nixpkgs = inputs.nixpkgs;
    nixpkgs-lib.inputs.nixpkgs.follows = "nixpkgs";
    hjem = inputs.hjem;
    flake-utils = inputs.flake-utils;
    quickshell = inputs.quickshell;
    hyprland = inputs.hyprland;
    niri = inputs.niri;
    niri-nix = inputs.niri-nix;
    smfh.inputs.hjem.follows = "hjem";
    neovim-nightly = {
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
    ambxst.quickshell.follows = "quickshell";
    sysc-greet = {
      inputs.utils.follows = "flake-utils";
      inputs.hyprland.follows = "hyprland";
      inputs.niri.follows = "niri-nix";
    };
  };

  outputs = with-inputs: {
    resolved = with-inputs;
  };

  flakeResult = with-inputs-lib sources inputSpec outputs;
  with-inputs = flakeResult.resolved;

  zpkgs =
    let
      lib = nixpkgs.lib;
      filesystem = lib.filesystem;
      callPackageWith = lib.callPackageWith;
      system = nixpkgs.stdenv.hostPlatform.system;
      pkgs = import sources.nixpkgs {
        inherit system sources;
        config.allowUnfree = true;
      };
      callPackage = callPackageWith pkgs;
    in
    {
      customDeri = filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) newScope;
        inherit callPackage;
        directory = self.paths.pkgs;
      };
    };

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
          with-inputs-lib
          with-inputs
          ;
        zpkgs = zpkgs.customDeri;
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
