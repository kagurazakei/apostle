{
  modules.hosts.kagura =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.openrgb-with-all-plugins
      ];
    };
}
