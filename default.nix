let
  defaultInputs = import ./.tack;
  mkConfig =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      system = builtins.currentSystem;
      pkgs = import inputs.nixpkgs { inherit lib system; };
      myLibs = import ./utils;
      username = "antonio";
    in
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
            pkgs
            ;
        };
      }
    )
    |> (result: result.config);

  self = mkConfig defaultInputs;
  outputs = mkConfig;
in
self // { inherit outputs; }
