let
  isFunction = f: builtins.isFunction f;
in
username: dots:
{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) inputs;
  inherit (config.hjem.users.${username}.impure) dotsDir;
  args = {
    inherit
      lib
      config
      inputs
      dotsDir
      ;
  };
  resolveSource =
    dot:
    dot |> (x: if isFunction x then x args else x) |> (x: if isFunction dot then x else dotsDir + x);
  normalize = dot: dot |> resolveSource |> (source: { inherit source; });
  result =
    dots
    |> lib.mapAttrs (_: normalize)
    |> (files: {
      hjem.users.${username}.xdg.config.files = files;
    });
in
result
