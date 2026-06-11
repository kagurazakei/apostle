{
  modules.services.noctalia-greeter =
    {
      noctalia-greeter,
      lib,
      config,
      ...
    }:
    {
      imports = [ noctalia-greeter.nixosModules.default ];
      options = {
        dm.noctalia-greeter.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
      config = lib.mkIf (config.dm.noctalia-greeter.enable) {
        programs.noctalia-greeter = {
          enable = true;
          greeter-args = "uwsm start mango-uwsm.desktop";
        };
      };
    };
}
