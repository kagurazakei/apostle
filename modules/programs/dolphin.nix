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
      hj = {
        systemd.services = {
          udiskie = {
            description = "Udiskie Systemd Service";
            after = [ "graphical-session.target" ];
            partOf = [ "graphical-session.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.udiskie}/bin/udiskie";
              Restart = "on-failure";
            };
          };
        };
      };
      services.udisks2 = {
        enable = true;
      };
      hj.xdg.config.files = {
        "udiskie/config.yml".text = ''
          program_options:
          automount: true
          tray: auto
          notify: true
          file_manager: ${pkgs.kdePackages.dolphin}/bin/dolphin
          udisks_version: 2
        '';
        "dolphinrc".source = config.impure-dots + "/dolphinrc";
        "kdeglobals".source = config.impure-dots + "/kdeglobals";
      };
    };
}
