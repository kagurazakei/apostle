{
  modules.programs.noctalia =
    { noctalia, ... }:
    {
      imports = [ noctalia.hjemModules ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
    };
}
