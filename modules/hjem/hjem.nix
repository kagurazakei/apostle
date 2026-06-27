{
  inputs,
  self,
  zpkgs,
  lib,
  myLibs,
  username,
  ...
}:
{
  modules.hjem._ =
    { pkgs, config, ... }:
    {
      imports = [
        (import inputs.hjem { inherit pkgs; }).nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "${username}" ])
        (lib.mkAliasOptionModule [ "impure-dots" ] [ "hjem" "users" "${username}" "impure" "dotsDir" ])
      ];

      hjem = {
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
        clobberByDefault = true;
        extraModules = [
          inputs.qtengine.hjemModules.default
          inputs.hjem-impure.hjemModules.default
          inputs.hjem-rum.hjemModules.default
        ];
      };
      hjem.users.${username} = {
        clobberFiles = true;
        user = username;
        directory = config.users.users.${username}.home;
        packages = import (self.paths.modules + "/users/antonio/_packages.nix") {
          inherit
            inputs
            pkgs
            self
            zpkgs
            ;
        };
        files = {
          ".face.icon".source = self.paths.dots + "/profile.png";
        };
        xdg.config.files = {
          "htop".source = myLibs.mkStoreSymlink self.paths.dots + "/htop";
          "booru".source = myLibs.mkStoreSymlink self.paths.dots + "/booru";
          "uwsm".source = myLibs.mkStoreSymlink self.paths.dots + "/uwsm";
          "cachix/cachix.dhall".source = config.age.secrets.cachix.path;
        };
      };
    };
}
