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
    let
      hjemPkg = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
    in
    { }
    |> (_: {
      imports = [
        (import inputs.hjem { inherit pkgs; }).nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "${username}" ])
        (lib.mkAliasOptionModule [ "impure-dots" ] [ "hjem" "users" "${username}" "impure" "dotsDir" ])
      ];
    })
    |> (
      attrs:
      attrs
      // {
        hjem = {
          linker = hjemPkg;
          clobberByDefault = true;
          extraModules = [
            inputs.qtengine.hjemModules.default
            inputs.hjem-impure.hjemModules.default
            inputs.hjem-rum.hjemModules.default
          ];
        };
      }
    )
    |> (
      attrs:
      attrs
      // {
        hjem = attrs.hjem // {
          users.${username} = {
            clobberFiles = true;
            user = username;
            directory = config.users.users.${username}.home;
            packages = import ../users/antonio/_packages.nix {
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
              "yazi/theme.toml".text = lib.mkForce ''
                [icon]
                prepend_dirs = [
                  { name = "desktop", text = "" },
                  { name = "dev", text = "" },
                  { name = "documents", text = "" },
                  { name = "downloads", text = "" },
                  { name = "music", text = "" },
                  { name = "games", text = "󰊴" },
                  { name = "pictures", text = "" },
                  { name = "videos", text = "" },
                ]
                [flavor]
                dark = "oxocarbon"
              '';
            };
          };
        };
      }
    );
}
