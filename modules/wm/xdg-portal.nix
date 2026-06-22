{
  modules.wm._ =
    { pkgs, ... }:
    let
      noRounding = ''
        * {
                  border-radius: 0px !important;
          }
        window {
                  border-radius: 0px !important;
               }
        window, decoration, decoration-overlay, headerbar, .titlebar {
            border-radius: 0px !important;
            border-bottom-left-radius: 0px !important;
            border-bottom-right-radius: 0px !important;
            border-top-left-radius: 0px !important;
            border-top-right-radius: 0px !important;
        }
      '';
    in
    {
      hj = {
        xdg.config.files."gtk-4.0/gtk.css".text = noRounding;
        xdg.config.files."gtk-3.0/gtk.css".text = noRounding;
      };
      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/start-hyprland";
          };
          niri = {
            prettyName = "Niri The Goat";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      };
      xdg = {
        terminal-exec = {
          enable = true;
          settings = {
            default = [
              "kitty.desktop"
            ];
          };
        };
      };
      xdg.portal = {
        enable = true;
        configPackages = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-termfilechooser
        ];
      };
    };
}
