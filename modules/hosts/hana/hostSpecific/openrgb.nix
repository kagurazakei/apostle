{
  modules.hosts.hana =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.openrgb-with-all-plugins
      ];
    };
}
