{
  inputs,
  lib,
  ...
}:
{
  modules.services._sysc-greet =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.sysc-greet.nixosModules.default ];
      options = {
        dm.sysc-greet.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
      config = lib.mkIf (config.dm.sysc-greet.enable) {
        services.sysc-greet = {
          enable = true;
          compositor = "niri";
          hyprlandPackage = pkgs.hyprland;
          niriPackage = inputs.niri-nix.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
        };
      };
    };
}
