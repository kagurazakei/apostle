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
      };
    };
}
