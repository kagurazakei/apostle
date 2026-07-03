{
  modules.programs.walker = { pkgs, lib, ... }: {
    services.elephant = {
      enable = true;
    };
    hj = {
      packages = [ pkgs.walker ];
      systemd.services = {
        walker = {
          description = "Walker Launcher Systemd Service";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
            Restart = "on-failure";
          };
        };
      };
    };
  };
}
