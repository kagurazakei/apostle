let
  defaultInputs = import ./.tack;
  mkConfig =
    inputs:
    {
      system = inputs.system or builtins.currentSystem;
      lib = inputs.nixpkgs.lib;
      username = "antonio";
      myLibs = import ./modules/utils;
      inherit inputs;
    }
    |> (
      ctx:
      ctx
      // {
        pkgs = import ctx.inputs.nixpkgs {
          inherit (ctx) system;
          config.allowUnfree = true;
        };
      }
    )
    |> (
      ctx:
      ctx
      // {
        specialArgs = {
          inherit self;
          inherit (ctx)
            myLibs
            inputs
            username
            system
            pkgs
            ;
        };
      }
    )
    |> (
      ctx:
      [ ./modules ]
      |> (
        dirs:
        ctx.myLibs.recursiveImport {
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
        ctx.lib.evalModules {
          modules = [ { inherit imports; } ];
          inherit (ctx) specialArgs;
        }
      )
      |> (result: result.config)
    );
  self = mkConfig defaultInputs;
  outputs = mkConfig;
in
self // { inherit outputs; }
