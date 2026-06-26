{ self, ... }:
{
  modules.programs.noctalia =
    { noctalia, zpkgs, ... }:
    {
      hjem.extraModules = [ noctalia.hjemModules.default ];
      hj = {
        programs.noctalia = {
          enable = true;
          package = zpkgs.noctalia;
          systemd = {
            enable = true;
            target = "graphical-session.target";
          };
        };
        xdg.config.files = {
          "noctalia/config.toml".source = self.paths.dots + "/noctalia/config.toml";
        };
      };
    };
}
