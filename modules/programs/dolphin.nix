{
  modules.programs.dolphin =
    {
      pkgs,
      config,
      zpkgs,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs.kdePackages;
        [
          gwenview
          ark
          kservice
          kde-cli-tools
          ffmpegthumbs
          kio
          kio-extras
          kio-fuse
          kimageformats
          kdegraphics-thumbnailers
          kirigami
        ]
        ++ [
          pkgs.udiskie
          zpkgs.dolphin
        ];
      services.udisks2.enable = true;
      hj = {
        systemd.services = {
          udiskie = {
            description = "Hjem Udiskie Service";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.udiskie}/bin/udiskie -t";
              Restart = "on-failure";
            };
          };
        };
      };
      hj.xdg.config.files = {
        "udiskie/config.yml" = {
          source = pkgs.writeText "udiskie-config.yml" (
            pkgs.lib.generators.toYAML { } {
              program_options = {
                automount = true;
                tray = "auto";
                notify = true;
                file_manager = "${zpkgs.dolphin}/bin/dolphin";
                udisks_version = 2;
              };
            }
          );
        };
        "dolphinrc".source = config.impure-dots + "/dolphinrc";
        "kdeglobals".source = config.impure-dots + "/kdeglobals";
      };
    };
}
