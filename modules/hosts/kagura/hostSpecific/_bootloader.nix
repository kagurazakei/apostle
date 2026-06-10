{ inputs, ... }:
{
  modules.hosts.kagura =
    { pkgs, ... }:
    {
      boot = {
        consoleLogLevel = 0;
      };
      programs.plymouth = {
        enable = true;
      };

      environment.systemPackages = [
        (pkgs.callPackage (inputs.shizuruPkgs + "/pkgs/default.nix") { }).kureiji-ollie-cursors
      ];
    };
}
