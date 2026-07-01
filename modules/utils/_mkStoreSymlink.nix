let
  sources = import ../../.tack;
  pkgs = import sources.nixpkgs { };
  isImpure = builtins.getEnv "IMPURE" == "true";
  lib = sources.nixpkgs.lib;
  concat =
    base: suffix:
    if builtins.isString base && builtins.isString suffix then
      base + suffix
    else if builtins.isPath base then
      toString base + suffix
    else
      builtins.throw "mkStoreSymlink: cannot concatenate ${builtins.typeOf base} with ${builtins.typeOf suffix}";

  mkSymlink =
    pathOrParts:
    lib.pipe pathOrParts [
      (
        x:
        if builtins.isFunction x then
          x concat
        else if builtins.isList x then
          builtins.foldl' concat (builtins.elemAt x 0) (builtins.tail x)
        else
          x
      )
      (x: if builtins.isPath x then toString x else x)
      (
        absolutePath:
        if isImpure then
          pkgs.runCommand "mkSymlink-${builtins.baseNameOf absolutePath}" { } ''
            ln -sfn ${absolutePath} $out
          ''
        else
          absolutePath
      )
    ];
in
mkSymlink
