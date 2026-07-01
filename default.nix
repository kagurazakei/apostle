let
  defaultInputs = import ./.tack;
  mkConfig =
    inputs:
    let
      system = inputs.system or builtins.currentSystem;
      lib = inputs.nixpkgs.lib;
      username = "antonio";
      myLibs = import ./modules/utils;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit
          self
          myLibs
          inputs
          username
          system
          pkgs
          ;
      };
    in
    [ ./modules ]
    |> (
      dirs:
      myLibs.recursiveImport {
        inherit dirs;
        excludePrefixedWith = [
          "_"
          "+"
          "utils"
        ];
      }
    )
    |> (
      imports:
      lib.evalModules {
        modules = [ { inherit imports; } ];
        inherit specialArgs;
      }
    )
    |> (result: result.config);

  self = mkConfig defaultInputs;
  outputs = mkConfig;
in
self // { inherit outputs; }
