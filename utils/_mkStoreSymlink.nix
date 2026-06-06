let
  sources = import ../.tack;
  pkgs = import sources.nixpkgs { };

  # Helper to concatenate paths
  concat =
    base: suffix:
    if builtins.isString base && builtins.isString suffix then
      base + suffix
    else if builtins.isPath base then
      toString base + suffix
    else
      builtins.throw "mkStoreSymlink: cannot concatenate ${builtins.typeOf base} with ${builtins.typeOf suffix}";

in
pathOrParts:
let
  # Handle different input types
  finalPath =
    if builtins.isFunction pathOrParts then
      pathOrParts concat
    else if builtins.isList pathOrParts then
      builtins.foldl' concat (builtins.elemAt pathOrParts 0) (builtins.tail pathOrParts)
    else
      pathOrParts;

  absolutePath = if builtins.isPath finalPath then toString finalPath else finalPath;
  isImpure = builtins.getEnv "IMPURE";
in
if isImpure == "true" then
  pkgs.runCommand "mkSymlink-${builtins.baseNameOf absolutePath}" { } ''
    ln -sfn ${absolutePath} $out
  ''
else
  absolutePath
