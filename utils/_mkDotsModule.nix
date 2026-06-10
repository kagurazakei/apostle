let
  sources = import ../.tack;
  pkgs = import sources.nixpkgs { };
  isFunction = f: builtins.isFunction f;
in
username: dots:
{ config, lib, ... }:
let
  dotsDir = config.hjem.users.${username}.impure.dotsDir;
  args = { inherit lib config dotsDir; };
  normalize = dot: if isFunction dot then { source = dot args; } else { source = dotsDir + dot; };
in
{
  hjem.users.${username}.xdg.config.files = lib.mapAttrs (_: dot: normalize dot) dots;
}
