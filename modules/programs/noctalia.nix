{
  modules.programs.noctalia =
    { noctalia, ... }:
    {
      hjem.extraModules = [ noctalia.hjemModules.default ];
      programs.noctalia = {
        enable = true;
        systemd = {
          enable = true;
          target = "graphical-session.desktop";
        };
      };
    };
}
