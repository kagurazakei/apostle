{
  modules.nixos.misc_steam =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        misc.steam.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
      config = lib.mkIf (config.misc.steam.enable) {
        environment.systemPackages = [
          pkgs.mangohud
          pkgs.protonup-ng
        ];

        programs.gamemode.enable = true;

        # programs.steam = {
        #   enable = false;
        #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        #   gamescopeSession.enable = true;
        # };
      };
    };
}
