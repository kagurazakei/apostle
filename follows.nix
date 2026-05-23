{ sources, inputs, ... }:
let
  with-inputs-lib = import sources.with-inputs;
  inputSpec = {
    nixpkgs = inputs.nixpkgs;
    hjem = inputs.hjem;
    flake-utils = inputs.flake-utils;
    quickshell = inputs.quickshell;
    hyprland = inputs.hyprland;
    niri = inputs.niri;
    niri-nix = {
      outPath = inputs.niri-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
    ambxst = {
      outPath = inputs.ambxst;
      inputs.quickshell.follows = "quickshell";
    };
    sysc-greet = {
      inputs.utils.follows = "flake-utils";
      inputs.hyprland.follows = "hyprland";
      inputs.niri.follows = "niri-nix";
    };
  };

  flakeResult = with-inputs-lib sources inputSpec (with-inputs: {
    resolved = with-inputs;
  });
in
flakeResult.resolved
