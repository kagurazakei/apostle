{
  utils,
  username,
  zpkgs,
  ...
}:
{
  modules.programs.dots_mango = utils.mkDotsModule username {
    "mango/animation.conf" = "/mango/animation.conf";
    "mango/autostart.sh" = "/mango/autostart.sh";
    "mango/bind.conf" = "/mango/bind.conf";
    "mango/env.conf" = "/mango/env.conf";
    "mango/rules.conf" = "/mango/rules.conf";
    "mango/hardware.conf" = d: d.dotsDir + "/mango/${d.lib.toLower d.config.networking.hostName}.conf";
    "mango/config.conf" = "/mango/config.conf";
    "mango/noctalia.conf" = "/mango/noctalia.conf";
  };

  modules.wm.mango =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkOption
        mkIf
        mkForce
        ;
      cfg = config.wm.mango;

      uwsmWithPlugin = pkgs.symlinkJoin {
        inherit (pkgs.uwsm) pname version;
        paths = [ pkgs.uwsm ];
        postBuild = ''
          ln -sf ${zpkgs.mangowc.uwsm-plugin} $out/share/uwsm/plugins/mango.sh
        '';
        meta = pkgs.uwsm.meta // {
          outputsToInstall = [ "out" ];
        };
      };
    in
    {

      options.wm.mango = {
        enable = mkOption {
          type = lib.types.bool;
          default = false;
        };
        package = mkOption {
          type = lib.types.package;
          default = zpkgs.mangowc;
        };
        withUWSM = mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable UWSM for mangoWC";
        };
      };

      config = mkIf cfg.enable {
        environment.systemPackages = [
          cfg.package
          pkgs.wlsunset
        ];

        systemd.user.services.hypridle.path = mkForce [ cfg.package ];

        # REQUIRES uwsm finalize in autostart.sh
        programs.uwsm = mkIf cfg.withUWSM {
          enable = true;
          package = uwsmWithPlugin;
          waylandCompositors.mango = {
            prettyName = "MangoWC";
            comment = "Mango compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/mango";
          };
        };

        xdg.portal = {
          enable = true;
          wlr.enable = true;
          configPackages = [ cfg.package ];
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-wlr
          ];
          config.mango = {
            # borrowed from config for sway
            default = [ "kde" ];
            "org.freedesktop.impl.portal.ScreenCast" = "wlr";
            "org.freedesktop.impl.portal.Screenshot" = "wlr";
            "org.freedesktop.impl.portal.Inhibit" = "none";
            "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          };
        };

        services.dbus.packages = lib.mkDefault [ pkgs.thunar ];
        security.polkit.enable = true;
        programs.xwayland.enable = true;

        services = {
          displayManager.sessionPackages = mkIf (!cfg.withUWSM) [ cfg.package ];
          graphical-desktop.enable = true;
        };
      };
    };
}
