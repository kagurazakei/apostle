{
  self,
  utils,
  username,
  ...
}:
{

  modules.programs.dots_hyprland = utils.mkDotsModule username {
    "hypr/hyprland.lua" = "/hyprland/hyprland.lua";
    "hypr/keybinds.lua" = "/hyprland/keybinds.lua";
    "hypr/windowRules.lua" = "/hyprland/windowRules.lua";
    "hypr/animations" = "/hyprland/animations";
    "hypr/hyprcolors.lua" = "/hyprland/hyprcolors.lua";
    "hypr/hypridle.conf" = "/hyprland/hypridle.conf";
    "ambxst/binds.json" = "/ambxst/binds.json";
    "ambxst/config/theme.json" = "/ambxst/theme.json";
    "ambxst/config/compositor.json" = "/ambxst/compositor.json";
  };
  modules.wm.hyprland =
    {
      pkgs,
      lib,
      config,
      inputs,
      hyprland,
      ...
    }:
    let
      hyprview = (pkgs.callPackage (inputs.hyprview + "/default.nix") { });
    in
    {
      imports = [
        self.modules.wm._
      ];

      options = {
        wm.hyprland.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        wm.hyprland.buildFromSrc = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      config = lib.mkIf (config.wm.hyprland.enable) {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
          xwayland.enable = true;
        }
        // lib.optionalAttrs (config.wm.hyprland.buildFromSrc) {
          package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };
        xdg.portal = {
          config.hyprland = {
            default = [
              "hyprland"
              "kde"
            ];
          };
        };

        #polkit
        environment.systemPackages = [
          pkgs.libsForQt5.qt5.qtwayland
        ]
        ++ builtins.attrValues {
          inherit hyprview;
          inherit (pkgs.kdePackages) qtwayland;
          inherit (pkgs)
            hyprpolkitagent
            hyprshutdown
            app2unit
            kitty
            ;
        };

      };
    };
}
