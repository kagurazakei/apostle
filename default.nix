let
  inputs = import ./.tack;
  lib = inputs.nixpkgs.lib;
  system = builtins.currentSystem;
  pkgs = import inputs.nixpkgs {
    inherit lib system;
  };
  myLibs = import ./utils;
  username = "antonio";

  self =
    null
    |> (
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
    |> (imports: { imports = imports; })
    |> (
      modules:
      lib.evalModules {
        modules = [ modules ];
        specialArgs = {
          inherit
            self
            myLibs
            inputs
            username
            system
            ;
          inherit pkgs;
        };
      }
    )
    |> (result: result.config);
in
self
