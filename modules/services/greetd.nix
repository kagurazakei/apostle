{
  inputs,
  lib,
  username,
  ...
}:
{
  modules.services._greetd =
    { config, pkgs, ... }:
    let
      inherit (lib) getExe;
      tuigreet = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      options = {
        dm.tuigreet.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
      config = lib.mkIf (config.dm.tuigreet.enable) {
        services.greetd = {
          enable = true;
          settings.default_session = {
            command = getExe tuigreet "--cmd uwsm start niri-uwsm.desktop";
            user = "greeter";
          };
          settings.initial_session = {
            command = "uwsm start niri-uwsm.desktop";
            user = "${username}";
          };
        };
        environment.etc."tuigreet/config.toml".source =
          (pkgs.formats.toml { }).generate "tuigreet-config.toml"
            {
              display = {
                greeting = "Welcome to the fold of nixos.";
                show_time = true;
                show_title = false;
              };
              layout = {
                window_padding = 1;
                widgets = {
                  time_position = "top";
                  status_position = "hidden";
                };
              };
              secret = {
                mode = "characters";
                characters = "*";
              };
              remember = {
                default_user = "${username}";
                username = true;
              };
            };
      };
    };
}
