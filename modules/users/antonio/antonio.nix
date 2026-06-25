{
  self,
  username,
  ...
}:
{
  modules.hjem.${username} =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.modules.hjem.theming
      ];
      theming = {
        inherit username;
        enable = true;
        qt = {
          colorScheme = self.paths.dots + "/theme/rose-pine.colors";
          iconTheme = "oomox-tokyodark-terminal";
        };
        gtk = {
          name = "oomox-snazzy";
        };
        cursor = {
          name = "Yuurei-Angel";
          size = 32;
        };
      };
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "input"
          "wheel"
          "video"
          "render"
          "libvrtd"
          "plugdev"
          "seat"
        ];
        shell = pkgs.master.fish;
      };
      programs.fish = {
        enable = true;
      };
    };
}
