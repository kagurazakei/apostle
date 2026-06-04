{
  self,
  inputs,
  utils,
  username,
  ...
}:
{

  modules.programs.dots_niri = utils.mkDotsModule username {
    "niri/config.kdl" = d: d.dotsDir + "/niri/${d.lib.toLower d.config.networking.hostName}.kdl";
    "niri/noctalia.kdl" = "/niri/noctalia.kdl";
  };
  modules.wm.niri =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.modules.wm._
        inputs.niri-nix.nixosModules.default
      ];
      options = {
        wm.niri.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        wm.niri.buildFromSrc = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      config = (lib.mkIf config.wm.niri.enable) {
        programs.niri = {
          enable = true;
          useNautilus = false;
          withUWSM = false;
          withXDG = false;
        }
        // lib.optionalAttrs (config.wm.niri.buildFromSrc) {
          package = pkgs.niri-unstable;
        };

        xdg.portal = {
          config.niri = {
            "org.freedesktop.impl.portal.FileChooser" = lib.mkForce "kde";
            # "org.freedesktop.impl.portal.ScreenCast" = "gnome";
            # "org.freedesktop.portal.ScreenCast" = "gnome";
          };
        };

        environment.systemPackages = [
          pkgs.fuzzel
          pkgs.xwayland-satellite
        ];
      };
    };
}
