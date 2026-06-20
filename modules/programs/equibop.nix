{
  modules.programs.equibop =
    {
      pkgs,
      zpkgs,
      ...
    }:
    {
      hj = {
        packages = [
          zpkgs.equibop
          pkgs.arrpc
        ];
        xdg.config.files."equibop/settings.json" = {
          source = pkgs.writeText "settings.json" (
            builtins.toJSON {
              discordBranch = "canary";
              minimizeToTray = true;
              arRPC = true;
              splashColor = "rgb(205, 214, 244)";
              splashBackground = "rgb(10, 10, 19)";
              hardwareVideoAcceleration = true;
              clickTrayToShowHide = true;
              splashPixelated = true;
              tray = true;
            }
          );
        };
        systemd.services = {
          arrpc = {
            description = "arRPC Systemd Service";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.arrpc}/bin/arrpc";
              Restart = "on-failure";
            };
          };
        };
      };
    };
}
