{ username, ... }:
{
  modules.services.dms-greeter =
    {
      pkgs,
      ...
    }:
    {

      services.displayManager.dms-greeter = {
        enable = true;
        compositor = {
          name = "hyprland";
        };
        configHome = "/home/${username}";
        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
        quickshell.package = pkgs.quickshell;
      };
    };
}
