{
  modules.programs.noctalia =
    { noctalia, ... }:
    {
      hjem.extraModules = [ noctalia.hjemModules.default ];
      hj = {
        programs.noctalia = {
          enable = true;
          systemd = {
            enable = true;
            target = "graphical-session.target";
          };
        };
      };
    };
}
