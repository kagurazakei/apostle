{
  myLibs,
  username,
  pkgs,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  yaziTheme = tomlFormat.generate "theme.toml" {
    icon = {
      prepend_dirs = [
        {
          name = "desktop";
          text = "";
        }
        {
          name = "dev";
          text = "";
        }
        {
          name = "documents";
          text = "";
        }
        {
          name = "downloads";
          text = "";
        }
        {
          name = "music";
          text = "";
        }
        {
          name = "games";
          text = "󰊴";
        }
        {
          name = "pictures";
          text = "";
        }
        {
          name = "videos";
          text = "";
        }
      ];
    };
    flavor = {
      dark = "oxocarbon";
    };
  };
in
{

  modules.programs.dots_yazi = myLibs.mkDotsModule username {
    "yazi/init.lua" = "/yazi/init.lua";
    "yazi/yazi.toml" = "/yazi/yazi.toml";
    "yazi/keymap.toml" = "/yazi/keymap.toml";
    "yazi/package.toml" = "/yazi/package.toml";
    "yazi/flavors/oxocarbon.yazi/flavor.toml" = "/yazi/flavors/oxocarbon.yazi/flavor.toml";
    "yazi/flavors/catppuccin-macchiato.yazi/flavor.toml" =
      "/yazi/flavors/catppuccin-macchiato.yazi/flavor.toml";
  };

  modules.programs.yazi =
    {
      pkgs,
      ...
    }:
    {
      hj = {
        packages = with pkgs; [
          yazi
        ];
        xdg.config.files."yazi/theme.toml" = {
          source = yaziTheme;
        };
      };
    };
}
