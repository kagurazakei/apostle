{ inputs, ... }:
{
  modules.services.flatpak =
    { pkgs, ... }:
    {
      hjem.extraModules = [
        (inputs.nix-flatpak + "/modules/hjem.nix")
      ];
      hj = {
        services = {
          flatpak = {
            enable = true;
            packages = [
              "com.github.tchx84.Flatseal"
              "app.opencomic.OpenComic"
            ];
          };
        };
        systemd.services = {
          hjem-impure = {
            description = "Hjem Impure Systemd Service";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "/etc/profiles/per-user/antonio/bin/hjem-impure";
              Restart = "on-failure";
            };
          };
          arrpc = {
            description = "arRPC Systemd Service";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            wantedBy = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.arrpc}/bin/arrpc";
              Restart = "on-failure";
            };
          };
        };
      };
    };
}
