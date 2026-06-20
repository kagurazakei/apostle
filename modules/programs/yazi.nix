{ myLibs, username, ... }:
{

  modules.programs.dots_yazi = myLibs.mkDotsModule username {
    "yazi/init.lua" = "/yazi/init.lua";
    "yazi/yazi.toml" = "/yazi/yazi.toml";
    "yazi/keymap.toml" = "/yazi/keymap.toml";
    "yazi/package.toml" = "/yazi/package.toml";
    "yazi/theme.toml" = "/yazi/theme.toml";
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
      };
    };
}
