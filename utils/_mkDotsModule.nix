let
  isFunction = f: builtins.isFunction f;
in
username: dots:
{ config, lib, ... }:
let
  dotsDir = config.hjem.users.${username}.impure.dotsDir;
  args = { inherit lib config dotsDir; };
  processDot =
    dot:
    lib.pipe dot [
      (x: if isFunction x then x args else x)
      (x: if isFunction dot then x else dotsDir + x)
      (source: { inherit source; })
    ];
  buildHjemConfig = lib.pipe dots [
    (lib.mapAttrs (_: processDot))
    (files: { hjem.users.${username}.xdg.config.files = files; })
  ];
in
buildHjemConfig
