{ inputs, ... }:
{
  modules.programs.noctalia = {
    imports = [ inputs.noctalia.hjemModules ];
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };
  };
}
