{
  username,
  inputs,
  ...
}:
{
  modules.programs.greetd =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) getExe;
      tuigreet = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = getExe tuigreet;
          user = "greeter";
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
}
