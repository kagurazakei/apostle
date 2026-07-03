{
  modules.hjem.theming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkOption mkIf;
      inherit (lib.types)
        package
        nullOr
        bool
        str
        ints
        oneOf
        path
        int
        listOf
        ;
      cfg = config.theming;

      mkFontOption = {
        family = mkOption {
          type = nullOr str;
          default = "Atkinson Hyperlegible Next Medium";
        };
        size = mkOption {
          type = nullOr int;
          default = 11;
        };
        weight = mkOption {
          type = nullOr int;
          default = -1;
        };
      };
      mkQtConfig =
        {
          colorScheme,
          iconTheme,
          style,
          font,
          fontFixed,
        }:
        {
          theme = {
            inherit colorScheme iconTheme style;
            font = {
              family = font.family;
              size = font.size;
              weight = font.weight;
            };
            fontFixed = {
              family = fontFixed.family;
              size = fontFixed.size;
              weight = fontFixed.weight;
            };
          };
          misc.singleClickActivate = false;
        };
      mkEnvVars =
        {
          cursorSize,
          cursorName,
          username,
        }:
        ''
          XCURSOR_SIZE=${toString cursorSize}
          XCURSOR_THEME=${cursorName}
          HYPRCURSOR_SIZE=${toString cursorSize}
          HYPRCURSOR_THEME=${cursorName}
          QT_QPA_PLATFORMTHEME=qtengine
          DCONF_PROFILE=${username}
        '';
      mkDconfSettings =
        {
          cursorName,
          cursorSize,
          gtkName,
          iconThemeName,
          qtFont,
        }:
        {
          "org/gnome/desktop/interface" = {
            cursor-theme = cursorName;
            cursor-size = lib.gvariant.mkUint32 cursorSize;
            gtk-theme = gtkName;
            color-scheme = "prefer-dark";
            icon-theme = iconThemeName;
            font-name = "${qtFont.family} ${toString qtFont.size}";
          };
        };
      mkIconThemeIndex = cursorName: ''
        [Icon Theme]
        Name=Default
        Inherits=${cursorName}
      '';

    in
    null
    |> (_: {
      options.theming = {
        enable = mkOption {
          type = nullOr bool;
          default = false;
        };
        username = mkOption {
          type = str;
          default = "";
        };

        gtk = {
          package = mkOption {
            type = nullOr package;
            default = pkgs.adw-gtk3;
          };
          name = mkOption {
            type = nullOr str;
            default = "adw-gtk3-dark";
          };
        };
        cursor = {
          package = mkOption {
            type = nullOr package;
            default = pkgs.kdePackages.breeze;
          };
          name = mkOption {
            type = nullOr str;
            default = "Breeze_Light";
          };
          size = mkOption {
            type = nullOr ints.u8;
            default = 24;
          };
        };
        iconTheme = {
          package = mkOption {
            type = nullOr package;
            default = pkgs.papirus-icon-theme;
          };
          name = mkOption {
            type = nullOr str;
            default = "Papirus-Dark";
          };
        };

        qt = {
          packages = mkOption {
            type = nullOr (listOf package);
            default = [
              pkgs.kdePackages.breeze
              pkgs.kdePackages.breeze-icons
            ];
          };
          colorScheme = mkOption {
            type = oneOf [
              path
              str
            ];
            default = "";
          };
          iconTheme = mkOption {
            type = nullOr str;
            default = "breeze-dark";
          };
          style = mkOption {
            type = nullOr str;
            default = "breeze";
          };
          font = mkFontOption;
          fontFixed = mkFontOption;
        };
      };
    })
    |> (
      options:
      options
      // {
        config = mkIf cfg.enable {
          assertions = [
            {
              assertion = !(cfg.enable && cfg.username == "");
              message = "this is scuffed but username must be manually set";
            }
          ];
          hjem.users.${cfg.username} = {
            programs.qtengine = {
              enable = true;
              config = mkQtConfig {
                colorScheme = cfg.qt.colorScheme;
                iconTheme = cfg.qt.iconTheme;
                style = cfg.qt.style;
                font = cfg.qt.font;
                fontFixed = cfg.qt.fontFixed;
              };
            };
            xdg.data.files = {
              "icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";
              "icons/default/index.theme".text = mkIconThemeIndex cfg.cursor.name;
            };
            xdg.config.files."environment.d/envvars.conf".text = mkEnvVars {
              cursorSize = cfg.cursor.size;
              cursorName = cfg.cursor.name;
              username = cfg.username;
            };
            packages = [
              cfg.gtk.package
              cfg.iconTheme.package
            ]
            ++ cfg.qt.packages;
          };
          programs.dconf.profiles.${cfg.username}.databases = [
            {
              settings = mkDconfSettings {
                cursorName = cfg.cursor.name;
                cursorSize = cfg.cursor.size;
                gtkName = cfg.gtk.name;
                iconThemeName = cfg.iconTheme.name;
                qtFont = cfg.qt.font;
              };
            }
          ];
        };
      }
    );
}
