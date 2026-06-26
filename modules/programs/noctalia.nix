{
  modules.programs.noctalia =
<<<<<<< HEAD
    { noctalia, zpkgs, ... }:
=======
    { noctalia, self, ... }:
>>>>>>> 484998f0e0e140de368d6dd411fbcd52cb72136b
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
